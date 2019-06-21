CLASS zjson_cl_example_provider DEFINITION
                                PUBLIC
                                FINAL
                                CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES: json_example_as_table  TYPE TABLE OF string WITH EMPTY KEY,
           json_example_as_text   TYPE string,
           json_example_as_binary TYPE xstring.

    METHODS constructor.

    METHODS get_example_from_include
      IMPORTING
        include_name  TYPE programm
      RETURNING
        VALUE(result) TYPE json_example_as_binary
      RAISING
        zjson_cx_error.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS convert_string_to_xstring
      IMPORTING
        json_example_as_text TYPE json_example_as_text
      RETURNING
        VALUE(result)        TYPE json_example_as_binary
      RAISING
        zjson_cx_error.

    METHODS convert_table_to_string
      IMPORTING
        table         TYPE json_example_as_table
      RETURNING
        VALUE(result) TYPE json_example_as_text
      RAISING
        zjson_cx_error.

    METHODS read_include_content
      IMPORTING
        include_name  TYPE programm
      RETURNING
        VALUE(result) TYPE json_example_as_table
      RAISING
        zjson_cx_error.
ENDCLASS.



CLASS zjson_cl_example_provider IMPLEMENTATION.
  METHOD constructor.
  ENDMETHOD.

  METHOD get_example_from_include.
    DATA(include_content) = read_include_content( include_name ).
    DATA(json_example_as_text) = convert_table_to_string( include_content ).
    result = convert_string_to_xstring( json_example_as_text ).
  ENDMETHOD.

  METHOD convert_table_to_string.
    LOOP AT table INTO DATA(line) FROM 4.
      IF line IS INITIAL OR strlen( line ) < 1.
        CONTINUE.
      ENDIF.

      IF line+0(1) = '*' OR line+0(1) = '"'.
        SHIFT line LEFT DELETING LEADING '*'.
      ENDIF.

      SHIFT line LEFT DELETING LEADING space.

      REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN line WITH space.

      result = |{ result }{ line }|.
    ENDLOOP.
  ENDMETHOD.

  METHOD read_include_content.
    READ REPORT include_name INTO result.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zjson_cx_error.
    ENDIF.
  ENDMETHOD.

  METHOD convert_string_to_xstring.
    TRY.
        result = cl_abap_codepage=>convert_to(
                 source                        = json_example_as_text
                  codepage                      = `UTF-8`
                  endian                        = space
                  replacement                   = '#'
                  ignore_cerr                   = abap_false ).
      CATCH cx_parameter_invalid_range cx_sy_codepage_converter_init cx_sy_conversion_codepage cx_parameter_invalid_type.
        RAISE EXCEPTION TYPE zjson_cx_error.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
