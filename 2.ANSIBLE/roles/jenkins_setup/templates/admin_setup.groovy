/*
 * Create an admin user.
 */

import jenkins.model.*
import hudson.security.*

println "--> creating admin user"

def adminUsername = "{{ KEYS.APP_USER }}"
def adminPassword = "{{ KEYS.APP_PASS }}"


def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount(adminUsername, adminPassword)
Jenkins.instance.setSecurityRealm(hudsonRealm)
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
Jenkins.instance.setAuthorizationStrategy(strategy)

Jenkins.instance.save()