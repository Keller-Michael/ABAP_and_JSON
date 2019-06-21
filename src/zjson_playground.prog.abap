*&---------------------------------------------------------------------*
*& Report zjson_playground
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zjson_playground.

INCLUDE zjson_example_data.

START-OF-SELECTION.
  TRY.
      " serialize object to JSON
      DATA(example_class) = NEW zjson_cl_example( ).

      example_class->text_value = 'Test123'.
      example_class->boolean_value = abap_true.
      example_class->integer_value = 256.
      example_class->structured_values-field1 = 'Text1'.
      example_class->structured_values-field2 = 'Text2'.

      DATA(json_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).

      CALL TRANSFORMATION id SOURCE oref = example_class RESULT XML json_writer.
      DATA(json_string) = cl_abap_codepage=>convert_from( json_writer->get_output( ) ).

      " deserialize object from JSON (read from include)
      FREE example_class.
      DATA(json_provider) = NEW zjson_cl_example_provider( ).

      DATA(example) = json_provider->get_example_from_include( 'ZJSON_EXAMPLE_DATA' ).

      CALL TRANSFORMATION id SOURCE XML example RESULT oref = example_class.
    CATCH zjson_cx_error INTO DATA(json_provider_error).
      WRITE: 'No JSON data.' COLOR COL_NEGATIVE.
      return.
    CATCH cx_transformation_error INTO DATA(transformation_error).
      WRITE: 'Transformation error.' COLOR COL_NEGATIVE.
      return.
  ENDTRY.

  WRITE 'Everything ok.' COLOR COL_POSITIVE.
