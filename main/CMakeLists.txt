# SPDX-License-Identifier: Apache-2.0
# esp-hosted P4-host camera app for the Waveshare ESP32-P4-Module-DEV-KIT.
# The application logic (camera + audio + the encrypted nn_netstream/nn_sectun
# uplink over the C6 Wi-Fi radio) is IDENTICAL to nn-app-media and to the
# ESP32-P4-WIFI6 variant — only the SILICON differs (this module is pre-3.0,
# see ../sdkconfig.board).  The esp-hosted SDIO transport and the whole camera
# pipeline are inherited unchanged, so we REUSE nn-app-media's app_main.c
# verbatim rather than duplicating a third copy.
# monorepo: sibling app dir; standalone clone: the nn-app-media SUBMODULE.
# Never a vendored copy — copies drift.
set(_media_main "${CMAKE_CURRENT_LIST_DIR}/../../nn-app-media/main")
if(NOT EXISTS "${_media_main}/app_main.c")
    set(_media_main "${CMAKE_CURRENT_LIST_DIR}/../nn-app-media/main")
endif()
if(NOT EXISTS "${_media_main}/app_main.c")
    message(FATAL_ERROR "app_main.c not found — init the nn-app-media submodule")
endif()

idf_component_register(
    SRCS "${_media_main}/app_main.c" "${_media_main}/lp_watchdog.c"
    INCLUDE_DIRS "${_media_main}" "."
    REQUIRES "nn_registry" "console" "nvs_flash" "esp_timer"
             "nn_camera" "nn_audio"
             "nn_netstream" "nn_sectun" "nn_crypto" "nn_ctrl" "nn_timesync" "nn_prov"
             "esp_wifi" "lwip" "esp_http_client" "esp_hosted" "esp_hal_wdt"
)
