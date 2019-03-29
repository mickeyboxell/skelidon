#
# Copyright (c) 2018 Oracle and/or its affiliates. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#Specifies container image and runs a container with that image 
FROM maven:3.5.2-jdk-8-alpine AS MAVEN_TOOL_CHAIN
#RUN mkdir /myvolume
#VOLUME /myvolume 
#Copies in the pom.xml from your current working directory on my laptop and copy it into the /tmp folder in the container
COPY pom.xml /tmp/
#Creates a metadata layer - effectively cd'ing in the container - this creates a new container/build layer
WORKDIR /tmp/
#Makes sure that the pom.xml is up to date
RUN mvn package -Dmaven.repo.local=/tmp/repository
#COPY /Users/mboxell/Desktop/Skelidon/src /tmp/src/ - doesn't seem to be copying in /src 
COPY /src /tmp/src/
RUN mvn package -Dmaven.repo.local=/tmp/repository
#-Dmaven.repo.local=/myvolume

#Staged builds allow you to minimize your image 
#FROM openjdk:8-jre-slim
FROM openjdk:8-jre-alpine

RUN mkdir /app
#From the old container 
COPY --from=MAVEN_TOOL_CHAIN /tmp/target/libs /app/libs
COPY --from=MAVEN_TOOL_CHAIN /tmp/target/quickstart-se.jar /app
#The command run to start the .jar file
CMD ["java", "-jar", "/app/quickstart-se.jar"]