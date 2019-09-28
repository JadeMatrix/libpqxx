ADD_EXECUTABLE(unit_runner ${PQXX_TEST_UNIT_SOURCES})
TARGET_SOURCES(unit_runner
    PRIVATE
        "runner.cxx"
        "test_array.cxx"
        "test_binarystring.cxx"
        "test_cancel_query.cxx"
        "test_connection.cxx"
        "test_cursor.cxx"
        "test_encodings.cxx"
        "test_error_verbosity.cxx"
        "test_errorhandler.cxx"
        "test_escape.cxx"
        "test_exceptions.cxx"
        "test_field.cxx"
        "test_float.cxx"
        "test_notification.cxx"
        "test_pipeline.cxx"
        "test_prepared_statement.cxx"
        "test_read_transaction.cxx"
        "test_result_iteration.cxx"
        "test_result_slicing.cxx"
        "test_row.cxx"
        "test_simultaneous_transactions.cxx"
        "test_sql_cursor.cxx"
        "test_stateless_cursor.cxx"
        "test_str.cxx"
        "test_strconv.cxx"
        "test_stream_from.cxx"
        "test_stream_to.cxx"
        "test_string_conversion.cxx"
        "test_subtransaction.cxx"
        "test_test_helpers.cxx"
        "test_thread_safety_model.cxx"
        "test_transaction.cxx"
        "test_transaction_base.cxx"
        "test_transactor.cxx"
        "test_type_name.cxx"
)
TARGET_LINK_LIBRARIES(unit_runner PRIVATE pqxx-shared)
ADD_TEST(
    NAME unit_runner
    WORKING_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
    COMMAND unit_runner
)
# INSTALL(
#     TARGETS unit_runner
#     EXPORT libpqxx-targets
#     RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
#     LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
#     ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
#     COMPONENT tests EXCLUDE_FROM_ALL
# )
