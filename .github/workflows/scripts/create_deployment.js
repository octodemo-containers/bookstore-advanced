//
// Creates a Deployment using the provided data
//

module.exports = async(payload) => {

  const environment = validateParameter(payload, 'environment'),
    context = validateParameter(payload, 'context'),
    github = validateParameter(payload, 'github'),
    containerRegistry = validateParameter(payload, 'containerRegistry'),
    appContainerImage = validateParameter(payload, 'appContainerImage'),
    appContainerVersion = validateParameter(payload, 'appContainerVersion'),
    databaseContainerImage = validateParameter(payload, 'databaseContainerImage'),
    databaseContainerVersion = validateParameter(payload, 'databaseContainerVersion'),
    sha = validateParameter(payload, 'sha'),
    head = validateParameter(payload, 'head');

  const isProduction = /^prod-.*/.test(environment),
    deploymentEnvironment = isProduction ? environment : `${environment}-${head}-gcp`;

  // A deployment payload for passing information of the components for the deployment
  const deploymentPayload = {
    container_registry: containerRegistry,
    app_container: {
      image: appContainerImage,
      version: appContainerVersion,
    },
    database_container: {
      image: databaseContainerImage,
      version: databaseContainerVersion,
    },
    sha: sha,
    environment: deploymentEnvironment,
    ref: context.ref,
  };

  console.log(JSON.stringify(deploymentPayload, null, 2));

  await github.repos.createDeployment({
    ...context.repo,
    ref: head,
    auto_merge: false,
    required_contexts: [],
    payload: JSON.stringify(deploymentPayload),
    environment: deploymentEnvironment,
    description: `Deploy to ${environment}`,
    transient_environment: !isProduction,
    production_environment: false, // Defaulting all environments to not be production types for now
    mediaType: { previews: ["flash", "ant-man"] }
  });
}

function validateParameter(payload, name) {
  const value = payload[name];

  if (!value) {
    throw new Error(`Required Parameter '${name}' was not provided.`);
  }
  return value;
}