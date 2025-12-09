<?php
/**
 * Uninstall script.
 *
 * Runs when the plugin is deleted (not deactivated).
 * Use this to clean up database tables, options, and transients.
 *
 * @package {{NAMESPACE}}
 */

declare(strict_types=1);

// Prevent direct access.
if ( ! defined( 'WP_UNINSTALL_PLUGIN' ) ) {
	exit;
}

// Delete plugin options.
// delete_option( '{{PLUGIN_SLUG}}_settings' );

// Delete transients.
// delete_transient( '{{PLUGIN_SLUG}}_cache' );

// Drop custom tables (if any).
// global $wpdb;
// $wpdb->query( "DROP TABLE IF EXISTS {$wpdb->prefix}{{PLUGIN_SLUG}}_table" );

// Clear scheduled hooks.
// wp_clear_scheduled_hook( '{{PLUGIN_SLUG}}_cron_event' );
