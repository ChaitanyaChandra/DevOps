import jenkins.*
import hudson.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.plugins.sshslaves.*;
import hudson.model.*
import jenkins.model.*
import hudson.security.*

final List<String> REQUIRED_PLUGINS = [
        "workflow-aggregator",
        "ws-cleanup", // workspace clean up
        "blueocean",  // for parallel pipeline visualization 
        "job-dsl", // for jobs automation
       // "authorize-project",  // authorize the groovy scripts
        "ansicolor", // color the output
        "aws-secrets-manager-credentials-provider",
        "badge", // custom badges in jenkins
]


if (Jenkins.instance.pluginManager.plugins.collect {
    it.shortName
}.intersect(REQUIRED_PLUGINS).size() != REQUIRED_PLUGINS.size()) {
    REQUIRED_PLUGINS.collect {
        Jenkins.instance.updateCenter.getPlugin(it).deploy()
    }.each {
        it.get()
    }
    Jenkins.instance.restart()
    println 'Run this script again after restarting to create the jobs!'
    throw new RestartRequiredException(null)
}

println "Plugins were installed successfully"