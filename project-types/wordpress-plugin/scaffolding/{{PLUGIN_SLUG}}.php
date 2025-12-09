<?php
/**
 * Plugin Name: {{PLUGIN_NAME}}
 * Plugin URI: {{PLUGIN_URI}}
 * Description: {{PLUGIN_DESCRIPTION}}
 * Version: 1.0.0
 * Author: {{AUTHOR_NAME}}
 * Author URI: {{AUTHOR_URI}}
 * License: GPL-2.0+
 * License URI: http://www.gnu.org/licenses/gpl-2.0.txt
 * Text Domain: {{PLUGIN_SLUG}}
 * Domain Path: /languages
 * Requires at least: {{WP_MIN_VERSION}}
 * Requires PHP: {{PHP_MIN_VERSION}}
 *
 * @package {{NAMESPACE}}
 */

declare(strict_types=1);

namespace {{NAMESPACE}};

// Prevent direct access.
if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

// Plugin constants.
define( '{{CONSTANT_PREFIX}}_VERSION', '1.0.0' );
define( '{{CONSTANT_PREFIX}}_PLUGIN_DIR', plugin_dir_path( __FILE__ ) );
define( '{{CONSTANT_PREFIX}}_PLUGIN_URL', plugin_dir_url( __FILE__ ) );
define( '{{CONSTANT_PREFIX}}_PLUGIN_BASENAME', plugin_basename( __FILE__ ) );

// Autoloader.
if ( file_exists( __DIR__ . '/vendor/autoload.php' ) ) {
	require_once __DIR__ . '/vendor/autoload.php';
}

/**
 * Initialize the plugin.
 *
 * @return void
 */
function init(): void {
	// Load text domain for translations.
	load_plugin_textdomain(
		'{{PLUGIN_SLUG}}',
		false,
		dirname( {{CONSTANT_PREFIX}}_PLUGIN_BASENAME ) . '/languages'
	);

	// Initialize plugin components.
	// Example: new Admin\Settings();
	// Example: new Frontend\Shortcodes();
}
add_action( 'plugins_loaded', __NAMESPACE__ . '\\init' );

/**
 * Plugin activation hook.
 *
 * @return void
 */
function activate(): void {
	// Activation tasks (create tables, set options, etc.).
	// flush_rewrite_rules();
}
register_activation_hook( __FILE__, __NAMESPACE__ . '\\activate' );

/**
 * Plugin deactivation hook.
 *
 * @return void
 */
function deactivate(): void {
	// Deactivation cleanup.
	// flush_rewrite_rules();
}
register_deactivation_hook( __FILE__, __NAMESPACE__ . '\\deactivate' );
