<?php
/**
 * Admin settings page.
 *
 * @package {{NAMESPACE}}
 */

declare(strict_types=1);

namespace {{NAMESPACE}}\Admin;

/**
 * Handles the plugin settings page in wp-admin.
 */
class Settings {

	/**
	 * Option name for storing settings.
	 *
	 * @var string
	 */
	private const OPTION_NAME = '{{PLUGIN_SLUG}}_settings';

	/**
	 * Menu slug for the settings page.
	 *
	 * @var string
	 */
	private const MENU_SLUG = '{{PLUGIN_SLUG}}-settings';

	/**
	 * Constructor.
	 */
	public function __construct() {
		add_action( 'admin_menu', array( $this, 'add_menu_page' ) );
		add_action( 'admin_init', array( $this, 'register_settings' ) );
	}

	/**
	 * Add the settings page to the admin menu.
	 *
	 * @return void
	 */
	public function add_menu_page(): void {
		add_options_page(
			__( '{{PLUGIN_NAME}} Settings', '{{PLUGIN_SLUG}}' ),
			__( '{{PLUGIN_NAME}}', '{{PLUGIN_SLUG}}' ),
			'manage_options',
			self::MENU_SLUG,
			array( $this, 'render_settings_page' )
		);
	}

	/**
	 * Register plugin settings.
	 *
	 * @return void
	 */
	public function register_settings(): void {
		register_setting(
			self::MENU_SLUG,
			self::OPTION_NAME,
			array(
				'type'              => 'array',
				'sanitize_callback' => array( $this, 'sanitize_settings' ),
				'default'           => $this->get_defaults(),
			)
		);

		add_settings_section(
			'{{PLUGIN_SLUG}}_general',
			__( 'General Settings', '{{PLUGIN_SLUG}}' ),
			array( $this, 'render_section_description' ),
			self::MENU_SLUG
		);

		add_settings_field(
			'example_field',
			__( 'Example Field', '{{PLUGIN_SLUG}}' ),
			array( $this, 'render_example_field' ),
			self::MENU_SLUG,
			'{{PLUGIN_SLUG}}_general'
		);
	}

	/**
	 * Get default settings.
	 *
	 * @return array<string, mixed>
	 */
	private function get_defaults(): array {
		return array(
			'example_field' => '',
		);
	}

	/**
	 * Sanitize settings before saving.
	 *
	 * @param array<string, mixed> $input Raw input.
	 * @return array<string, mixed> Sanitized input.
	 */
	public function sanitize_settings( array $input ): array {
		$sanitized = array();

		$sanitized['example_field'] = isset( $input['example_field'] )
			? sanitize_text_field( $input['example_field'] )
			: '';

		return $sanitized;
	}

	/**
	 * Render the settings page.
	 *
	 * @return void
	 */
	public function render_settings_page(): void {
		if ( ! current_user_can( 'manage_options' ) ) {
			return;
		}

		?>
		<div class="wrap">
			<h1><?php echo esc_html( get_admin_page_title() ); ?></h1>
			<form action="options.php" method="post">
				<?php
				settings_fields( self::MENU_SLUG );
				do_settings_sections( self::MENU_SLUG );
				submit_button();
				?>
			</form>
		</div>
		<?php
	}

	/**
	 * Render section description.
	 *
	 * @return void
	 */
	public function render_section_description(): void {
		echo '<p>' . esc_html__( 'Configure the plugin settings below.', '{{PLUGIN_SLUG}}' ) . '</p>';
	}

	/**
	 * Render example field.
	 *
	 * @return void
	 */
	public function render_example_field(): void {
		$options = get_option( self::OPTION_NAME, $this->get_defaults() );
		$value   = $options['example_field'] ?? '';
		?>
		<input
			type="text"
			name="<?php echo esc_attr( self::OPTION_NAME ); ?>[example_field]"
			value="<?php echo esc_attr( $value ); ?>"
			class="regular-text"
		/>
		<p class="description">
			<?php esc_html_e( 'Enter a value for this example field.', '{{PLUGIN_SLUG}}' ); ?>
		</p>
		<?php
	}

	/**
	 * Get a setting value.
	 *
	 * @param string $key     Setting key.
	 * @param mixed  $default Default value if not set.
	 * @return mixed Setting value.
	 */
	public static function get( string $key, mixed $default = null ): mixed {
		$options = get_option( self::OPTION_NAME, array() );
		return $options[ $key ] ?? $default;
	}
}
