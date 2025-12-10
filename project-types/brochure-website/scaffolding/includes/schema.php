<?php

declare(strict_types=1);

/**
 * Schema.org JSON-LD Templates
 *
 * This file provides functions to generate structured data markup for SEO.
 * Copy this file to schema.php and customize for your project.
 *
 * Usage:
 *   <?php require_once __DIR__ . '/includes/schema.php'; ?>
 *   <?= renderLocalBusinessSchema($businessData); ?>
 */

/**
 * Render LocalBusiness schema
 *
 * @param array{
 *   name: string,
 *   description: string,
 *   url: string,
 *   phone: string,
 *   email: string,
 *   address: array{street: string, city: string, state: string, zip: string},
 *   geo: array{lat: float, lng: float},
 *   hours?: array<string, string>,
 *   logo?: string,
 *   image?: string,
 *   priceRange?: string,
 *   sameAs?: array<string>,
 *   businessType?: string
 * } $business Business data array
 * @return string JSON-LD script tag
 */
function renderLocalBusinessSchema(array $business): string
{
    // Use specific business type if provided, otherwise generic LocalBusiness
    $type = $business['businessType'] ?? 'LocalBusiness';

    $schema = [
        '@context' => 'https://schema.org',
        '@type' => $type,
        'name' => $business['name'],
        'description' => $business['description'],
        'url' => $business['url'],
        'telephone' => $business['phone'],
        'email' => $business['email'],
        'address' => [
            '@type' => 'PostalAddress',
            'streetAddress' => $business['address']['street'],
            'addressLocality' => $business['address']['city'],
            'addressRegion' => $business['address']['state'],
            'postalCode' => $business['address']['zip'],
            'addressCountry' => 'US',
        ],
        'geo' => [
            '@type' => 'GeoCoordinates',
            'latitude' => $business['geo']['lat'],
            'longitude' => $business['geo']['lng'],
        ],
    ];

    // Optional fields
    if (isset($business['hours'])) {
        $schema['openingHoursSpecification'] = formatOpeningHours($business['hours']);
    }

    if (isset($business['logo'])) {
        $schema['logo'] = $business['logo'];
    }

    if (isset($business['image'])) {
        $schema['image'] = $business['image'];
    }

    if (isset($business['priceRange'])) {
        $schema['priceRange'] = $business['priceRange'];
    }

    if (isset($business['sameAs'])) {
        $schema['sameAs'] = $business['sameAs'];
    }

    return renderSchemaScript($schema);
}

/**
 * Common Schema.org business types for LocalBusiness
 *
 * Use these values for the 'businessType' parameter in renderLocalBusinessSchema().
 * Full list: https://schema.org/LocalBusiness#subtypes
 *
 * @var array<string, string> Map of common business types to Schema.org types
 */
const SCHEMA_BUSINESS_TYPES = [
    'attorney' => 'Attorney',
    'lawyer' => 'Attorney',
    'accountant' => 'AccountingService',
    'restaurant' => 'Restaurant',
    'cafe' => 'CafeOrCoffeeShop',
    'bar' => 'BarOrPub',
    'dentist' => 'Dentist',
    'doctor' => 'Physician',
    'medical' => 'MedicalBusiness',
    'real_estate' => 'RealEstateAgent',
    'plumber' => 'Plumber',
    'electrician' => 'Electrician',
    'hvac' => 'HVACBusiness',
    'auto_repair' => 'AutoRepair',
    'beauty_salon' => 'BeautySalon',
    'hair_salon' => 'HairSalon',
    'spa' => 'DaySpa',
    'gym' => 'HealthClub',
    'store' => 'Store',
    'florist' => 'Florist',
    'bakery' => 'Bakery',
    'travel_agency' => 'TravelAgency',
    'insurance' => 'InsuranceAgency',
    'financial' => 'FinancialService',
    'veterinarian' => 'VeterinaryCare',
    'pet_store' => 'PetStore',
    'photographer' => 'Photographer',
    'general' => 'LocalBusiness',
];

/**
 * Get Schema.org type from business category
 *
 * @param string $category Business category (e.g., 'attorney', 'restaurant')
 * @return string Schema.org type
 */
function getSchemaBusinessType(string $category): string
{
    $normalized = strtolower(trim($category));
    return SCHEMA_BUSINESS_TYPES[$normalized] ?? 'LocalBusiness';
}

/**
 * Render Attorney/LegalService schema with practice areas
 *
 * @param array{
 *   name: string,
 *   description: string,
 *   url: string,
 *   phone: string,
 *   email: string,
 *   address: array{street: string, city: string, state: string, zip: string},
 *   geo: array{lat: float, lng: float},
 *   practiceAreas?: array<string>,
 *   hours?: array<string, string>,
 *   logo?: string,
 *   image?: string,
 *   sameAs?: array<string>
 * } $attorney Attorney/firm data
 * @return string JSON-LD script tag
 */
function renderAttorneySchema(array $attorney): string
{
    $schema = [
        '@context' => 'https://schema.org',
        '@type' => 'Attorney',
        'name' => $attorney['name'],
        'description' => $attorney['description'],
        'url' => $attorney['url'],
        'telephone' => $attorney['phone'],
        'email' => $attorney['email'],
        'address' => [
            '@type' => 'PostalAddress',
            'streetAddress' => $attorney['address']['street'],
            'addressLocality' => $attorney['address']['city'],
            'addressRegion' => $attorney['address']['state'],
            'postalCode' => $attorney['address']['zip'],
            'addressCountry' => 'US',
        ],
        'geo' => [
            '@type' => 'GeoCoordinates',
            'latitude' => $attorney['geo']['lat'],
            'longitude' => $attorney['geo']['lng'],
        ],
    ];

    // Add practice areas as knowsAbout
    if (isset($attorney['practiceAreas']) && count($attorney['practiceAreas']) > 0) {
        $schema['knowsAbout'] = $attorney['practiceAreas'];
    }

    if (isset($attorney['hours'])) {
        $schema['openingHoursSpecification'] = formatOpeningHours($attorney['hours']);
    }

    if (isset($attorney['logo'])) {
        $schema['logo'] = $attorney['logo'];
    }

    if (isset($attorney['image'])) {
        $schema['image'] = $attorney['image'];
    }

    if (isset($attorney['sameAs'])) {
        $schema['sameAs'] = $attorney['sameAs'];
    }

    return renderSchemaScript($schema);
}

/**
 * Render Organization schema
 *
 * @param array{
 *   name: string,
 *   url: string,
 *   logo: string,
 *   description?: string,
 *   sameAs?: array<string>
 * } $org Organization data
 * @return string JSON-LD script tag
 */
function renderOrganizationSchema(array $org): string
{
    $schema = [
        '@context' => 'https://schema.org',
        '@type' => 'Organization',
        'name' => $org['name'],
        'url' => $org['url'],
        'logo' => $org['logo'],
    ];

    if (isset($org['description'])) {
        $schema['description'] = $org['description'];
    }

    if (isset($org['sameAs'])) {
        $schema['sameAs'] = $org['sameAs'];
    }

    return renderSchemaScript($schema);
}

/**
 * Render WebSite schema with search action
 *
 * @param array{
 *   name: string,
 *   url: string,
 *   searchUrl?: string
 * } $site Website data
 * @return string JSON-LD script tag
 */
function renderWebSiteSchema(array $site): string
{
    $schema = [
        '@context' => 'https://schema.org',
        '@type' => 'WebSite',
        'name' => $site['name'],
        'url' => $site['url'],
    ];

    if (isset($site['searchUrl'])) {
        $schema['potentialAction'] = [
            '@type' => 'SearchAction',
            'target' => $site['searchUrl'] . '?q={search_term_string}',
            'query-input' => 'required name=search_term_string',
        ];
    }

    return renderSchemaScript($schema);
}

/**
 * Render BreadcrumbList schema
 *
 * @param array<array{name: string, url: string}> $breadcrumbs Array of breadcrumb items
 * @return string JSON-LD script tag
 */
function renderBreadcrumbSchema(array $breadcrumbs): string
{
    $items = [];
    $position = 1;

    foreach ($breadcrumbs as $crumb) {
        $items[] = [
            '@type' => 'ListItem',
            'position' => $position,
            'name' => $crumb['name'],
            'item' => $crumb['url'],
        ];
        $position++;
    }

    $schema = [
        '@context' => 'https://schema.org',
        '@type' => 'BreadcrumbList',
        'itemListElement' => $items,
    ];

    return renderSchemaScript($schema);
}

/**
 * Render FAQPage schema
 *
 * @param array<array{question: string, answer: string}> $faqs Array of FAQ items
 * @return string JSON-LD script tag
 */
function renderFAQSchema(array $faqs): string
{
    $mainEntity = [];

    foreach ($faqs as $faq) {
        $mainEntity[] = [
            '@type' => 'Question',
            'name' => $faq['question'],
            'acceptedAnswer' => [
                '@type' => 'Answer',
                'text' => $faq['answer'],
            ],
        ];
    }

    $schema = [
        '@context' => 'https://schema.org',
        '@type' => 'FAQPage',
        'mainEntity' => $mainEntity,
    ];

    return renderSchemaScript($schema);
}

/**
 * Render Service schema
 *
 * @param array{
 *   name: string,
 *   description: string,
 *   provider: string,
 *   areaServed?: string,
 *   image?: string
 * } $service Service data
 * @return string JSON-LD script tag
 */
function renderServiceSchema(array $service): string
{
    $schema = [
        '@context' => 'https://schema.org',
        '@type' => 'Service',
        'name' => $service['name'],
        'description' => $service['description'],
        'provider' => [
            '@type' => 'LocalBusiness',
            'name' => $service['provider'],
        ],
    ];

    if (isset($service['areaServed'])) {
        $schema['areaServed'] = $service['areaServed'];
    }

    if (isset($service['image'])) {
        $schema['image'] = $service['image'];
    }

    return renderSchemaScript($schema);
}

/**
 * Format opening hours for schema
 *
 * @param array<string, string> $hours Associative array of day => hours
 * @return array<array{dayOfWeek: string, opens: string, closes: string}>
 */
function formatOpeningHours(array $hours): array
{
    $dayMap = [
        'monday' => 'Monday',
        'tuesday' => 'Tuesday',
        'wednesday' => 'Wednesday',
        'thursday' => 'Thursday',
        'friday' => 'Friday',
        'saturday' => 'Saturday',
        'sunday' => 'Sunday',
    ];

    $specs = [];

    foreach ($hours as $day => $time) {
        $dayName = $dayMap[strtolower($day)] ?? $day;

        if (strtolower($time) === 'closed') {
            continue;
        }

        // Parse time range like "9:00 AM - 5:00 PM"
        if (preg_match('/(\d{1,2}:\d{2}\s*(?:AM|PM)?)\s*-\s*(\d{1,2}:\d{2}\s*(?:AM|PM)?)/i', $time, $matches)) {
            $specs[] = [
                '@type' => 'OpeningHoursSpecification',
                'dayOfWeek' => $dayName,
                'opens' => formatTimeForSchema($matches[1]),
                'closes' => formatTimeForSchema($matches[2]),
            ];
        }
    }

    return $specs;
}

/**
 * Format time string for schema (24-hour format)
 *
 * @param string $time Time string like "9:00 AM"
 * @return string Time in HH:MM format
 */
function formatTimeForSchema(string $time): string
{
    $timestamp = strtotime(trim($time));
    return $timestamp !== false ? date('H:i', $timestamp) : '00:00';
}

/**
 * Render schema as JSON-LD script tag
 *
 * @param array<string, mixed> $schema Schema data
 * @return string HTML script tag
 */
function renderSchemaScript(array $schema): string
{
    $json = json_encode($schema, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    return '<script type="application/ld+json">' . "\n" . $json . "\n" . '</script>';
}

/*
 * Example Usage:
 *
 * $businessData = [
 *     'name' => 'Smith & Associates Law Firm',
 *     'description' => 'Family law firm serving the greater Seattle area.',
 *     'url' => 'https://smithlaw.com',
 *     'phone' => '+1-206-555-1234',
 *     'email' => 'info@smithlaw.com',
 *     'address' => [
 *         'street' => '123 Main Street, Suite 400',
 *         'city' => 'Seattle',
 *         'state' => 'WA',
 *         'zip' => '98101',
 *     ],
 *     'geo' => [
 *         'lat' => 47.6062,
 *         'lng' => -122.3321,
 *     ],
 *     'hours' => [
 *         'monday' => '9:00 AM - 5:00 PM',
 *         'tuesday' => '9:00 AM - 5:00 PM',
 *         'wednesday' => '9:00 AM - 5:00 PM',
 *         'thursday' => '9:00 AM - 5:00 PM',
 *         'friday' => '9:00 AM - 5:00 PM',
 *         'saturday' => 'Closed',
 *         'sunday' => 'Closed',
 *     ],
 *     'logo' => 'https://smithlaw.com/images/logo.png',
 *     'priceRange' => '$$',
 *     'sameAs' => [
 *         'https://facebook.com/smithlaw',
 *         'https://linkedin.com/company/smithlaw',
 *     ],
 * ];
 *
 * echo renderLocalBusinessSchema($businessData);
 */
