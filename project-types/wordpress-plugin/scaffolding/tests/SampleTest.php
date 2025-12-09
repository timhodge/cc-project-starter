<?php
/**
 * Sample test class.
 *
 * @package {{PLUGIN_NAME}}
 */

declare(strict_types=1);

namespace {{NAMESPACE}}\Tests;

use PHPUnit\Framework\TestCase;

/**
 * Sample test class demonstrating testing patterns.
 */
class SampleTest extends TestCase {

    /**
     * Test that true is true (sanity check).
     */
    public function test_true_is_true(): void {
        $this->assertTrue(true);
    }

    /**
     * Example: Test a pure function.
     *
     * Replace with actual tests for your plugin's functions.
     */
    public function test_example_function(): void {
        // Arrange
        $input = 'hello';
        $expected = 'HELLO';

        // Act
        $result = strtoupper($input);

        // Assert
        $this->assertSame($expected, $result);
    }

    /**
     * Example: Test with data provider.
     *
     * @dataProvider addition_provider
     */
    public function test_addition(int $a, int $b, int $expected): void {
        $this->assertSame($expected, $a + $b);
    }

    /**
     * Data provider for addition test.
     *
     * @return array<string, array{int, int, int}>
     */
    public static function addition_provider(): array {
        return [
            'positive numbers' => [1, 2, 3],
            'negative numbers' => [-1, -2, -3],
            'mixed numbers'    => [-1, 2, 1],
            'zeros'            => [0, 0, 0],
        ];
    }
}
