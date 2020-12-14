//
// Simple script to extract build related information from the Action runtime environment to be used
// to build up the various parameters to be passed into Maven builds
//
const BRANCH_REGEX = /refs\/heads\/(.*)/


class BuildParameters {

    constructor(context, core) {
        this.context = context;
        this.core = core;
    }

    injectBuildParameters() {
        const core = this.core,
            context = this.context;

        const shortSha = context.sha.substring(0, 8);
        core.setOutput('github_short_sha', shortSha);

        core.setOutput('github_ref', context.ref);
        console.log(`GitHub Ref: ${context.ref}`);

        const branchNameMatch = BRANCH_REGEX.exec(context.ref),
            branchName = branchNameMatch ? branchNameMatch[1] : '';
        core.setOutput('github_ref_branch_name', branchName);
        console.log(`Resolved GitHub Branch Name: ${branchName}`);

        this.mavenVersionOutputs(branchName, shortSha);

        core.setOutput('github_organization_name', context.repo.owner); //Not used currently
        core.setOutput('github_repository_name', context.repo.repo);
        core.setOutput('github_repository', process.env.GITHUB_REPOSITORY);
        core.setOutput('container_name', `${context.repo.owner}/${context.repo.repo}`);
    }

    mavenVersionOutputs(branchName, shortSha) {
        const core = this.core;

        // Dependabot branches are not ideal as they blow up the version number and potentially contain characters we might find undesirable for versioning
        // As such we need to capture and santize these values to ensure short, meaningful and the non-breaking version numbers and container tags.
        const cleanBranchName = this.cleanBranchName(branchName);

        // Maven CD version number for the project is composed of '${revision}${changelist}${sha1}'
        //
        // We leave the revision as what is specified in the POM, but need to add context to the version number
        // with respect to the branch name and commit we are building from.
        //
        // We also need to append '-SNAPSHOT' to the end of the version number unless we are a release build, which
        // in the context of the Maven POM here, is the main branch (as that automatically deploys to prod).
        if (branchName === 'main' || branchName === 'master') {
            core.setOutput('maven_changelist', '');
            core.setOutput('maven_sha1', `-${shortSha}`);
        } else {
            core.setOutput('maven_changelist', `-${cleanBranchName}`);
            core.setOutput('maven_sha1', `-${shortSha}-SNAPSHOT`);
        }
    }

    cleanBranchName(name) {
        const matched = /dependabot\/(.*?)\//.exec(name)

        if (matched) {
            return `dbot-${matched[1]}`
        } else {
            return name;
        }
    }
}

module.exports = (context, core) => {
    return new BuildParameters(context, core);
}