# WordPress Plugin Development Skill

Guidelines for developing WordPress plugins following best practices.

---

## WordPress Coding Standards

### PHP

- **Use WordPress style**: Yoda conditions, spaces inside parentheses
- **Prefix everything**: Functions, classes, hooks, options, transients
- **Text domain**: All strings must be translatable

```php
<?php
// Good: WordPress style
if ( true === $is_active ) {
    $option = get_option( 'my_plugin_settings' );
}

// Bad: Non-WP style
if ($is_active === true) {
    $option = get_option('my_plugin_settings');
}
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Functions | `prefix_snake_case` | `my_plugin_get_settings()` |
| Classes | `Prefix_Title_Case` | `My_Plugin_Admin` |
| Constants | `PREFIX_UPPER_SNAKE` | `MY_PLUGIN_VERSION` |
| Hooks | `prefix_hook_name` | `my_plugin_before_save` |
| Options | `prefix_option_name` | `my_plugin_settings` |

---

## Security

### Input Validation

Always validate and sanitize input:

```php
<?php
// Sanitize text
$title = sanitize_text_field( $_POST['title'] );

// Sanitize email
$email = sanitize_email( $_POST['email'] );

// Sanitize URL
$url = esc_url_raw( $_POST['url'] );

// Sanitize textarea
$content = sanitize_textarea_field( $_POST['content'] );

// Sanitize integer
$id = absint( $_POST['id'] );

// Sanitize array of integers
$ids = array_map( 'absint', $_POST['ids'] );
```

### Output Escaping

Always escape output:

```php
<?php
// HTML attribute
echo '<input value="' . esc_attr( $value ) . '">';

// HTML content
echo '<p>' . esc_html( $text ) . '</p>';

// URL
echo '<a href="' . esc_url( $url ) . '">';

// JavaScript in HTML
echo '<script>var data = ' . wp_json_encode( $data ) . ';</script>';

// Translation with escaping
echo esc_html__( 'Hello World', 'text-domain' );
echo esc_html_e( 'Hello World', 'text-domain' );
```

### Nonce Verification

Verify nonces on all form submissions:

```php
<?php
// Create nonce field in form
wp_nonce_field( 'my_plugin_action', 'my_plugin_nonce' );

// Verify nonce on submission
if ( ! wp_verify_nonce( $_POST['my_plugin_nonce'], 'my_plugin_action' ) ) {
    wp_die( esc_html__( 'Security check failed', 'text-domain' ) );
}
```

### Capability Checks

Always check user capabilities:

```php
<?php
// For admin pages
if ( ! current_user_can( 'manage_options' ) ) {
    wp_die( esc_html__( 'Unauthorized', 'text-domain' ) );
}

// For specific posts
if ( ! current_user_can( 'edit_post', $post_id ) ) {
    return;
}
```

---

## Hooks and Filters

### Actions

```php
<?php
// Add action
add_action( 'init', 'my_plugin_init' );
add_action( 'wp_enqueue_scripts', 'my_plugin_enqueue_scripts' );
add_action( 'admin_menu', 'my_plugin_admin_menu' );

// Create custom action
do_action( 'my_plugin_before_save', $data );
```

### Filters

```php
<?php
// Add filter
add_filter( 'the_content', 'my_plugin_modify_content' );
add_filter( 'plugin_action_links_' . plugin_basename( __FILE__ ), 'my_plugin_action_links' );

// Create custom filter
$data = apply_filters( 'my_plugin_data', $data );
```

### Common Hooks

| Hook | When to Use |
|------|-------------|
| `plugins_loaded` | Initialize plugin (after all plugins loaded) |
| `init` | Register post types, taxonomies, shortcodes |
| `admin_init` | Admin initialization, register settings |
| `admin_menu` | Add admin menu pages |
| `wp_enqueue_scripts` | Enqueue frontend scripts/styles |
| `admin_enqueue_scripts` | Enqueue admin scripts/styles |
| `save_post` | Process post saves |
| `wp_ajax_{action}` | Handle AJAX for logged-in users |
| `wp_ajax_nopriv_{action}` | Handle AJAX for guests |

---

## Database

### Options API

```php
<?php
// Single option
update_option( 'my_plugin_version', '1.0.0' );
$version = get_option( 'my_plugin_version', '1.0.0' );
delete_option( 'my_plugin_version' );

// Array of options
$defaults = array(
    'enabled' => true,
    'limit'   => 10,
);
$settings = get_option( 'my_plugin_settings', $defaults );
```

### Transients

```php
<?php
// Set transient (expires in 1 hour)
set_transient( 'my_plugin_cache', $data, HOUR_IN_SECONDS );

// Get transient
$cached = get_transient( 'my_plugin_cache' );
if ( false === $cached ) {
    // Cache miss - fetch fresh data
    $data = expensive_operation();
    set_transient( 'my_plugin_cache', $data, HOUR_IN_SECONDS );
}

// Delete transient
delete_transient( 'my_plugin_cache' );
```

### Custom Tables

Use `$wpdb` with prepared statements:

```php
<?php
global $wpdb;
$table = $wpdb->prefix . 'my_plugin_data';

// Insert
$wpdb->insert(
    $table,
    array(
        'name'       => $name,
        'created_at' => current_time( 'mysql' ),
    ),
    array( '%s', '%s' )
);

// Select with prepare
$results = $wpdb->get_results(
    $wpdb->prepare(
        "SELECT * FROM $table WHERE status = %s LIMIT %d",
        'active',
        10
    )
);

// Update
$wpdb->update(
    $table,
    array( 'status' => 'inactive' ),
    array( 'id' => $id ),
    array( '%s' ),
    array( '%d' )
);
```

---

## AJAX

### Frontend AJAX

```php
<?php
// Enqueue script with localized data
function my_plugin_enqueue_scripts() {
    wp_enqueue_script( 'my-plugin', plugin_dir_url( __FILE__ ) . 'js/script.js', array( 'jquery' ), '1.0.0', true );
    wp_localize_script(
        'my-plugin',
        'myPluginAjax',
        array(
            'ajaxurl' => admin_url( 'admin-ajax.php' ),
            'nonce'   => wp_create_nonce( 'my_plugin_nonce' ),
        )
    );
}
add_action( 'wp_enqueue_scripts', 'my_plugin_enqueue_scripts' );

// Handle AJAX request
function my_plugin_ajax_handler() {
    check_ajax_referer( 'my_plugin_nonce', 'nonce' );

    if ( ! current_user_can( 'edit_posts' ) ) {
        wp_send_json_error( 'Unauthorized' );
    }

    $data = sanitize_text_field( $_POST['data'] );

    // Process...

    wp_send_json_success( array( 'message' => 'Done' ) );
}
add_action( 'wp_ajax_my_plugin_action', 'my_plugin_ajax_handler' );
add_action( 'wp_ajax_nopriv_my_plugin_action', 'my_plugin_ajax_handler' ); // For guests
```

### JavaScript

```javascript
jQuery(document).ready(function($) {
    $.ajax({
        url: myPluginAjax.ajaxurl,
        type: 'POST',
        data: {
            action: 'my_plugin_action',
            nonce: myPluginAjax.nonce,
            data: 'some value'
        },
        success: function(response) {
            if (response.success) {
                console.log(response.data.message);
            }
        }
    });
});
```

---

## Settings API

```php
<?php
function my_plugin_register_settings() {
    register_setting(
        'my_plugin_options',
        'my_plugin_settings',
        array(
            'sanitize_callback' => 'my_plugin_sanitize_settings',
            'default'           => array(),
        )
    );

    add_settings_section(
        'my_plugin_general',
        __( 'General Settings', 'text-domain' ),
        '__return_null',
        'my_plugin'
    );

    add_settings_field(
        'api_key',
        __( 'API Key', 'text-domain' ),
        'my_plugin_render_api_key_field',
        'my_plugin',
        'my_plugin_general'
    );
}
add_action( 'admin_init', 'my_plugin_register_settings' );

function my_plugin_sanitize_settings( $input ) {
    $sanitized = array();
    $sanitized['api_key'] = sanitize_text_field( $input['api_key'] ?? '' );
    return $sanitized;
}

function my_plugin_render_api_key_field() {
    $options = get_option( 'my_plugin_settings' );
    ?>
    <input type="text" name="my_plugin_settings[api_key]"
           value="<?php echo esc_attr( $options['api_key'] ?? '' ); ?>"
           class="regular-text">
    <?php
}
```

---

## Plugin Structure

Recommended directory layout:

```
my-plugin/
├── my-plugin.php           # Main plugin file
├── uninstall.php           # Cleanup on uninstall
├── readme.txt              # WordPress.org readme
├── composer.json
├── package.json            # If using build tools
├── src/
│   ├── Admin/              # Admin functionality
│   │   ├── Settings.php
│   │   └── Notices.php
│   ├── Frontend/           # Frontend functionality
│   │   └── Shortcodes.php
│   └── Core/               # Core classes
│       └── Plugin.php
├── assets/
│   ├── css/
│   ├── js/
│   └── images/
├── languages/              # Translation files
├── templates/              # Template files
└── tests/
    └── ...
```

---

## Internationalization

### Making Strings Translatable

```php
<?php
// Simple string
__( 'Hello', 'text-domain' );

// Echo string
_e( 'Hello', 'text-domain' );

// With escaping
esc_html__( 'Hello', 'text-domain' );
esc_html_e( 'Hello', 'text-domain' );

// Plural strings
sprintf(
    _n(
        '%d item',
        '%d items',
        $count,
        'text-domain'
    ),
    $count
);

// With context
_x( 'Post', 'noun', 'text-domain' );
```

### Loading Text Domain

```php
<?php
function my_plugin_load_textdomain() {
    load_plugin_textdomain(
        'text-domain',
        false,
        dirname( plugin_basename( __FILE__ ) ) . '/languages'
    );
}
add_action( 'plugins_loaded', 'my_plugin_load_textdomain' );
```

---

## Performance

### Lazy Loading

Only load what's needed:

```php
<?php
// Only load admin classes in admin
if ( is_admin() ) {
    require_once __DIR__ . '/src/Admin/Settings.php';
}

// Only load frontend on frontend
if ( ! is_admin() ) {
    require_once __DIR__ . '/src/Frontend/Shortcodes.php';
}
```

### Conditional Enqueuing

```php
<?php
function my_plugin_enqueue_scripts() {
    // Only on specific pages
    if ( ! is_singular( 'product' ) ) {
        return;
    }

    wp_enqueue_script( 'my-plugin' );
}
```

### Caching

Use transients for expensive operations:

```php
<?php
function my_plugin_get_remote_data() {
    $cached = get_transient( 'my_plugin_api_data' );
    if ( false !== $cached ) {
        return $cached;
    }

    $response = wp_remote_get( 'https://api.example.com/data' );
    if ( is_wp_error( $response ) ) {
        return array();
    }

    $data = json_decode( wp_remote_retrieve_body( $response ), true );
    set_transient( 'my_plugin_api_data', $data, DAY_IN_SECONDS );

    return $data;
}
```

---

## Testing

### Unit Tests with PHPUnit

```php
<?php
class My_Plugin_Test extends WP_UnitTestCase {

    public function test_option_default() {
        $this->assertEquals(
            array(),
            get_option( 'my_plugin_settings', array() )
        );
    }

    public function test_sanitize_settings() {
        $input = array( 'api_key' => '<script>alert("xss")</script>' );
        $sanitized = my_plugin_sanitize_settings( $input );
        $this->assertEquals( '', $sanitized['api_key'] );
    }
}
```

---

## Common Patterns

### Singleton Pattern

```php
<?php
final class My_Plugin {

    private static ?self $instance = null;

    public static function instance(): self {
        if ( null === self::$instance ) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    private function __construct() {
        $this->init();
    }

    private function init(): void {
        add_action( 'init', array( $this, 'register_post_types' ) );
    }
}

// Initialize
My_Plugin::instance();
```

### Admin Notice

```php
<?php
function my_plugin_admin_notice() {
    if ( get_option( 'my_plugin_notice_dismissed' ) ) {
        return;
    }
    ?>
    <div class="notice notice-info is-dismissible">
        <p><?php esc_html_e( 'Thanks for installing My Plugin!', 'text-domain' ); ?></p>
    </div>
    <?php
}
add_action( 'admin_notices', 'my_plugin_admin_notice' );
```

### Plugin Action Links

```php
<?php
function my_plugin_action_links( $links ) {
    $settings_link = sprintf(
        '<a href="%s">%s</a>',
        admin_url( 'options-general.php?page=my-plugin' ),
        esc_html__( 'Settings', 'text-domain' )
    );
    array_unshift( $links, $settings_link );
    return $links;
}
add_filter( 'plugin_action_links_' . plugin_basename( __FILE__ ), 'my_plugin_action_links' );
```
