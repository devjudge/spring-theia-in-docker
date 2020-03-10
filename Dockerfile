FROM maven:3.5.2-jdk-8-alpine AS MAVEN_TOOL_CHAIN

ARG workspace="none"

RUN apk add --update openssl

USER root

# Pre build commands
RUN wget https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/backend-project/pre-build.sh
RUN chmod 775 ./pre-build.sh
RUN sh pre-build.sh

# Install Workspace for Java

RUN if [ $workspace = "theia" ] ; then \
	wget -O ./pre-build.sh https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/theia/java/pre-build.sh \
    && chmod 775 ./pre-build.sh && sh pre-build.sh ; fi

WORKDIR /var/


RUN if [ $workspace = "theia" ] ; then \
	wget https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/theia/build.sh \
    && chmod 775 ./build.sh && sh build.sh ; fi

# Get RUN Script

WORKDIR /var/theia/

RUN if [ $workspace = "theia" ] ; then \
	wget https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/theia/run.sh \
    && chmod 775 ./run.sh ; fi

COPY pom.xml /tmp/
COPY src /tmp/src/
WORKDIR /tmp/

EXPOSE 8080


# Build the app
RUN wget -O ./build.sh https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/backend-project/springboot/maven/2.x/build.sh
RUN chmod 775 ./build.sh
RUN sh build.sh

# Add extra docker commands here (if any)...

# Run the app
RUN wget -O ./run.sh https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/backend-project/springboot/maven/2.x/run.sh
RUN chmod 775 ./run.sh
CMD sh run.sh
