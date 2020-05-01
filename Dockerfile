FROM openjdk:8-jdk-slim AS base

FROM base AS build

RUN apt update && apt install -y \
        wget

WORKDIR /app

RUN wget https://ci.nukkitx.com/job/NukkitX/job/Nukkit/job/master/lastSuccessfulBuild/artifact/target/nukkit-1.0-SNAPSHOT.jar

FROM base AS run

COPY --from=build /app /app

RUN useradd --user-group \
            --no-create-home \
            --home-dir /data \
            --shell /usr/sbin/nologin \
            minecraft

VOLUME /data /home/minecraft

EXPOSE 19132

RUN chown -R minecraft:minecraft /app

USER minecraft:minecraft

WORKDIR /data

ADD nukkit.yml /data

ENTRYPOINT [ "java" ]
CMD [ "-jar", "/app/nukkit-1.0-SNAPSHOT.jar", "--no-wizard" ]
