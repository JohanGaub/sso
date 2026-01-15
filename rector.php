<?php

declare(strict_types=1);

use Rector\Config\RectorConfig;
use Rector\Set\ValueObject\LevelSetList;
use Rector\Symfony\Set\SymfonySetList;
use Rector\Doctrine\Set\DoctrineSetList;

return RectorConfig::configure()
    ->withPaths([
        __DIR__ . '/src',
        __DIR__ . '/config',
    ])
    ->withSets([
        // PHP 8.2 features - toutes les améliorations PHP jusqu'à 8.2
        LevelSetList::UP_TO_PHP_82,
        // Symfony sets - règles spécifiques Symfony
        SymfonySetList::SYMFONY_CODE_QUALITY,
        SymfonySetList::SYMFONY_CONSTRUCTOR_INJECTION,
        // Doctrine sets (si Doctrine est utilisé)
        DoctrineSetList::DOCTRINE_CODE_QUALITY,
        DoctrineSetList::DOCTRINE_DBAL_30,
        DoctrineSetList::DOCTRINE_ORM_29,
    ])
    ->withSkip([
        // Skip Kernel.php car généré automatiquement
        __DIR__ . '/src/Kernel.php',
    ])
    ->withParallel()
    ->withCache(__DIR__ . '/var/cache/rector');

