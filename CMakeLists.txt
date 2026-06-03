cmake_minimum_required(VERSION 3.16)

set(EXTRA_COMPONENT_DIRS esp-idf-sx127x/components/lora esp-idf-sx126x/components/ra01s)
set(COMPONENTS json lora main mqtt esp-tls mbedtls nvs nvs_flash esp_wifi esp_netif ra01s spiffs tcp_transport esp_http_server)
include($ENV{IDF_PATH}/tools/cmake/project.cmake)
project(smoke-x)

if(WIN32)
    add_custom_target(www
        COMMAND powershell.exe -NoProfile -ExecutionPolicy Bypass -File "${PROJECT_SOURCE_DIR}/web_ui/build.ps1" "${PROJECT_SOURCE_DIR}/web_ui"
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/web_ui"
    )
else()
    add_custom_target(www
        COMMAND "${PROJECT_SOURCE_DIR}/web_ui/build.sh" "${PROJECT_SOURCE_DIR}/web_ui"
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/web_ui"
    )
endif()
spiffs_create_partition_image(storage web_ui/dist FLASH_IN_PROJECT DEPENDS www)
