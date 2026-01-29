<?php

declare(strict_types=1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

final class TestController extends AbstractController
{
    #[Route('/test', name: 'app_test')]
    public function index(Request $request): Response
    {
        $isHttps = $request->isSecure();
        $scheme = $request->getScheme();
        $host = $request->getHost();
        $uri = $request->getUri();

        return $this->render('test/index.html.twig', [
            'isHttps' => $isHttps,
            'scheme' => $scheme,
            'host' => $host,
            'uri' => $uri,
            'badgeClass' => $scheme === 'https' ? 'https' : 'http',
            'badgeText' => $scheme === 'https' ? 'HTTPS' : 'HTTP',
            'certBadgeClass' => $isHttps ? 'https' : 'http',
            'certBadgeText' => $isHttps ? '🔒 HTTPS Actif' : '⚠️ HTTP (Non sécurisé)',
        ]);
    }
}
