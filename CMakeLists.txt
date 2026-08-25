cmake_minimum_required(VERSION 3.16)
# Monorepo: the shared component set one level up.  Standalone clone: this repo
# carries NO component code at all — the nn_* wrappers come from the
# nn-app-media submodule and the esp_* camera components from nn-app-media's
# OWN nn-modules submodule (hence `git submodule update --init --recursive`).
if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/../components")
    set(EXTRA_COMPONENT_DIRS "${CMAKE_CURRENT_LIST_DIR}/../components")
else()
    set(EXTRA_COMPONENT_DIRS "${CMAKE_CURRENT_LIST_DIR}/nn-app-media/components")
    list(APPEND EXTRA_COMPONENT_DIRS "${CMAKE_CURRENT_LIST_DIR}/nn-app-media/nn-modules/components")
endif()
if(NOT SDKCONFIG_DEFAULTS)
    set(_shared "${CMAKE_CURRENT_LIST_DIR}/../nn-app-media")
    if(NOT EXISTS "${_shared}/sdkconfig.defaults")
        set(_shared "${CMAKE_CURRENT_LIST_DIR}/nn-app-media")   # standalone: submodule
    endif()
    # ORDER MATTERS — later files win.  IDF also auto-loads each entry's
    # `.esp32p4` sibling, so the camera/silicon settings in
    # sdkconfig.defaults.esp32p4 land here too; sdkconfig.board comes last so it
    # can override them for this board's pre-3.0 silicon.
    set(SDKCONFIG_DEFAULTS "${_shared}/sdkconfig.defaults;${_shared}/sdkconfig.transport.sdio;${CMAKE_CURRENT_LIST_DIR}/sdkconfig.board")
endif()
include($ENV{IDF_PATH}/tools/cmake/project.cmake)
project(nn-app-camera-esp32p4module-sdio-ov5647)
