FROM confluentinc/cp-kafka-connect:7.8.0

USER root

ARG DEBEZIUM_VERSION=3.0.2.Final
ARG OJDBC_VERSION=23.6.0.24.10

RUN mkdir -p /usr/share/java/debezium-postgres \
             /usr/share/java/debezium-jdbc \
    && curl -fSL --retry 3 \
       "https://repo.maven.apache.org/maven2/io/debezium/debezium-connector-postgres/${DEBEZIUM_VERSION}/debezium-connector-postgres-${DEBEZIUM_VERSION}-plugin.tar.gz" \
       | tar -xz --strip-components=1 \
         -C /usr/share/java/debezium-postgres \
    && curl -fSL --retry 3 \
       "https://repo.maven.apache.org/maven2/io/debezium/debezium-connector-jdbc/${DEBEZIUM_VERSION}/debezium-connector-jdbc-${DEBEZIUM_VERSION}-plugin.tar.gz" \
       | tar -xz --strip-components=1 \
         -C /usr/share/java/debezium-jdbc \
    && curl -fSL --retry 3 \
       "https://repo.maven.apache.org/maven2/com/oracle/database/jdbc/ojdbc11/${OJDBC_VERSION}/ojdbc11-${OJDBC_VERSION}.jar" \
       -o /usr/share/java/debezium-jdbc/ojdbc11.jar

USER appuser