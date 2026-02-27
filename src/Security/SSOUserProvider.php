<?php

declare(strict_types=1);

namespace App\Security;

use Symfony\Component\Security\Core\Exception\UnsupportedUserException;
use Symfony\Component\Security\Core\Exception\UserNotFoundException;
use Symfony\Component\Security\Core\User\UserInterface;
use Symfony\Component\Security\Core\User\UserProviderInterface;

/**
 * @implements UserProviderInterface<UserInterface>
 */
final class SSOUserProvider implements UserProviderInterface
{
    public function loadUserByIdentifier(string $identifier): UserInterface
    {
        throw new UserNotFoundException(\sprintf('SSO user provider not implemented for identifier "%s".', $identifier));
    }

    public function refreshUser(UserInterface $user): UserInterface
    {
        throw new UnsupportedUserException('SSO user provider does not support refreshing users yet.');
    }

    public function supportsClass(string $class): bool
    {
        return false;
    }
}
