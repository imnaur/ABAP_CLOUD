CLASS zcx_05_failed DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA carrier_id TYPE /dmo/carrier_id.

    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    METHODS constructor
      IMPORTING
        !textid    LIKE if_t100_message=>t100key OPTIONAL
        !previous  LIKE previous OPTIONAL
        carrier_id TYPE /dmo/carrier_id OPTIONAL.

    CONSTANTS:
      BEGIN OF carrier_not_exist,
        msgid TYPE symsgid VALUE 'Z05_MESSAGES',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE 'carrier_id',
        attr2 TYPE scx_attrname VALUE 'attr2',
        attr3 TYPE scx_attrname VALUE 'attr3',
        attr4 TYPE scx_attrname VALUE 'attr4',
      END OF carrier_not_exist.

    CONSTANTS:
      BEGIN OF carrier_no_read_auth,
        msgid TYPE symsgid VALUE 'Z05_MESSAGES',
        msgno TYPE symsgno VALUE '020',
        attr1 TYPE scx_attrname VALUE 'carrier_id',
        attr2 TYPE scx_attrname VALUE 'attr2',
        attr3 TYPE scx_attrname VALUE 'attr3',
        attr4 TYPE scx_attrname VALUE 'attr4',
      END OF carrier_no_read_auth.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_05_failed IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor(
    previous = previous
    ).
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    IF carrier_id IS NOT INITIAL.
      me->carrier_id = carrier_id.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
