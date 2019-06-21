CLASS zjson_cl_example DEFINITION
                          PUBLIC
                          FINAL
                          CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_serializable_object.

    types percentage type p LENGTH 5 DECIMALS 2.

    TYPES: BEGIN OF line_type,
             line  TYPE string,
             value TYPE string,
           END OF line_type.

    TYPES table_type TYPE STANDARD TABLE OF line_type WITH EMPTY KEY.

    TYPES: BEGIN OF structured,
             field1 TYPE string,
             field2 TYPE string,
           END OF structured.

    DATA: text_value             TYPE string,
          boolean_value          TYPE abap_bool,
          integer_value          TYPE i,
          negative_integer_value TYPE i,
          percentage_value       type percentage,
          null_value             TYPE string,
          structured_values      TYPE structured,
          table_lines            TYPE table_type.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS serialize_helper
      EXPORTING
        text_value             TYPE string
        boolean_value          TYPE string
        integer_value          TYPE i
        negative_integer_value TYPE i
        percentage_value       type percentage
        null_value             TYPE string
        structured_values      TYPE structured
        table_lines            TYPE table_type.

    METHODS deserialize_helper
      IMPORTING
        text_value             TYPE string
        boolean_value          TYPE string
        integer_value          TYPE i
        negative_integer_value TYPE i
        percentage_value       type percentage
        null_value             TYPE string
        structured_values      TYPE structured
        table_lines            TYPE table_type.
ENDCLASS.



CLASS zjson_cl_example IMPLEMENTATION.
  METHOD serialize_helper.
    text_value = me->text_value.

    IF me->boolean_value = abap_true.
      boolean_value = 'true'.
    ELSE.
      boolean_value = 'false'.
    ENDIF.

    integer_value = me->integer_value.
    negative_integer_value = me->negative_integer_value.

    percentage_value = me->percentage_value.

    structured_values = me->structured_values.

    INSERT LINES OF me->table_lines INTO TABLE table_lines.
  ENDMETHOD.

  METHOD deserialize_helper.
    me->text_value = text_value.

    IF boolean_value = 'true'.
      me->boolean_value = abap_true.
    ELSE.
      me->boolean_value = abap_false.
    ENDIF.

    me->integer_value = integer_value.
    me->negative_integer_value = negative_integer_value.

    me->percentage_value = percentage_value.

    IF null_value = 'null'.
      CLEAR me->null_value.
    ENDIF.

    me->structured_values = structured_values.

    INSERT LINES OF table_lines INTO TABLE me->table_lines.
  ENDMETHOD.
ENDCLASS.
