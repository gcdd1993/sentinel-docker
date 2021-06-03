FROM adoptopenjdk/openjdk11-openj9:alpine-jre
LABEL app="sentinel dashboard" \
    version="1.8.1" \
    description="alibaba sentinel dashboard" \
    author="https://gcdd1993.github.io"

WORKDIR /app
COPY releases/sentinel-dashboard-1.8.1.jar /app/sentinel-dashboard.jar

ENV DASHBOARD_PORT 8080
ENV USERNAME sentinel
ENV PASSWORD sentinel

EXPOSE $DASHBOARD_PORT
CMD ["java","-jar","/app/sentinel-dashboard.jar","-Dserver.port=$DASHBOARD_PORT","-Dcsp.sentinel.dashboard.server=localhost:$DASHBOARD_PORT","-Dproject.name=sentinel-dashboard","-Dauth.username=$USERNAME","-Dauth.password=$PASSWORD"]