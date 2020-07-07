FROM gcr.io/cloud-builders/javac:latest

USER root
ENV CMDTOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip" \
    CMDTOOLS_SHA="89f308315e041c93a37a79e0627c47f21d5c5edbe5e80ea8dc0aac8a649e0e92 commandlinetools-linux-6609375_latest.zip" \
    ANDROID_HOME="/usr/local/android-sdk" \
    ANDROID_VERSION=29 \
    ANDROID_BUILD_TOOLS_VERSION=29.0.3

# Install necessary tools
RUN apt-get update && apt-get -y install build-essential file curl && \
    curl -fLs $CMDTOOLS_URL | tee commandlinetools.zip | sha256sum
    

# Download Android SDK
RUN mkdir -p "$ANDROID_HOME/cmdline-tools" .android \
    && cd "$ANDROID_HOME/cmdline-tools" \
    && unzip /commandlinetools.zip \
    && rm /commandlinetools.zip \
    && mkdir "$ANDROID_HOME/licenses" || true \
    && yes | $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager --sdk_root="$ANDROID_HOME" --licenses
# Install Android Build Tool and Libraries
RUN $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager --sdk_root="$ANDROID_HOME" --update
RUN $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager --sdk_root="$ANDROID_HOME" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"
