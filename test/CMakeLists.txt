ADD_EXECUTABLE(runner)
TARGET_SOURCES(runner PRIVATE
    "runner.cxx"
    "test00.cxx"
    "test01.cxx"
    "test02.cxx"
    "test04.cxx"
    "test07.cxx"
    "test10.cxx"
    "test11.cxx"
    "test12.cxx"
    "test13.cxx"
    "test14.cxx"
    "test16.cxx"
    "test17.cxx"
    "test18.cxx"
    "test20.cxx"
    "test21.cxx"
    "test26.cxx"
    "test29.cxx"
    "test30.cxx"
    "test31.cxx"
    "test32.cxx"
    "test37.cxx"
    "test39.cxx"
    "test46.cxx"
    "test48.cxx"
    "test49.cxx"
    "test50.cxx"
    "test51.cxx"
    "test52.cxx"
    "test53.cxx"
    "test54.cxx"
    "test55.cxx"
    "test56.cxx"
    "test57.cxx"
    "test58.cxx"
    "test59.cxx"
    "test60.cxx"
    "test61.cxx"
    "test62.cxx"
    "test69.cxx"
    "test70.cxx"
    "test71.cxx"
    "test72.cxx"
    "test74.cxx"
    "test75.cxx"
    "test76.cxx"
    "test77.cxx"
    "test78.cxx"
    "test79.cxx"
    "test82.cxx"
    "test84.cxx"
    "test87.cxx"
    "test88.cxx"
    "test89.cxx"
    "test90.cxx"
    "test93.cxx"
)
TARGET_LINK_LIBRARIES(runner PRIVATE pqxx-shared)
TARGET_COMPILE_DEFINITIONS(
    runner
    PRIVATE
        ${PQXX_PRIVATE_COMPILE_DEFINITIONS}
        ${PQXX_PUBLIC_COMPILE_DEFINITIONS}
)
ADD_TEST(
    NAME runner
    WORKING_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
    COMMAND runner
)
# INSTALL(
#     TARGETS runner
#     EXPORT libpqxx-targets
#     RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
#     LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
#     ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
#     COMPONENT tests EXCLUDE_FROM_ALL
# )

ADD_SUBDIRECTORY("unit/")
