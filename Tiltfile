k8s_yaml('target/app.yaml')
docker_build('phx.ocir.io/oracle-cloudnative/tilt/quickstart-se', '.')
k8s_resource('quickstart-se', port_forwards='31000:31000')