<?php
/**
 * PHPUnit bootstrap file for WordPress plugin tests.
 *
 * @package {{PLUGIN_NAME}}
 */

declare(strict_types=1);

// Load Composer autoloader.
require_once dirname(__DIR__) . '/vendor/autoload.php';

// Load Yoast PHPUnit Polyfills.
require_once dirname(__DIR__) . '/vendor/yoast/phpunit-polyfills/phpunitpolyfills-autoload.php';

// Determine if we're running in WordPress test environment.
$wp_tests_dir = getenv('WP_TESTS_DIR');

if ($wp_tests_dir) {
    // Running with WordPress test suite.
    require_once $wp_tests_dir . '/includes/functions.php';

    /**
     * Manually load the plugin being tested.
     */
    function _manually_load_plugin(): void {
        require dirname(__DIR__) . '/{{PLUGIN_SLUG}}.php';
    }
    tests_add_filter('muplugins_loaded', '_manually_load_plugin');

    // Start up the WP testing environment.
    require_once $wp_tests_dir . '/includes/bootstrap.php';
} else {
    // Running without WordPress (unit tests only).
    // Define WordPress constants for standalone tests.
    if (! defined('ABSPATH')) {
        define('ABSPATH', '/tmp/wordpress/');
    }
}
