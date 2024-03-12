! SPDX-Identifer: MIT
module test_string_intrinsic
    use testdrive, only : new_unittest, unittest_type, error_type, check
    use stdlib_string_type
    implicit none

    abstract interface
        !> Actual tester working on a string type and a fixed length character
        !> representing the same character sequence
        subroutine check1_interface(error, str1, chr1)
            import :: string_type, error_type
            type(error_type), allocatable, intent(out) :: error
            type(string_type), intent(in) :: str1
            character(len=*), intent(in) :: chr1
        end subroutine check1_interface

        !> Actual tester working on two pairs of string type and fixed length
        !> character representing the same character sequences
        subroutine check2_interface(error, str1, chr1, str2, chr2)
            import :: string_type, error_type
            type(error_type), allocatable, intent(out) :: error
            type(string_type), intent(in) :: str1, str2
            character(len=*), intent(in) :: chr1, chr2
        end subroutine check2_interface
    end interface

contains


    !> Collect all exported unit tests
    subroutine collect_string_intrinsic(testsuite)
        !> Collection of tests
        type(unittest_type), allocatable, intent(out) :: testsuite(:)

        testsuite = [ &
            new_unittest("lgt", test_lgt), &
            new_unittest("llt", test_llt), &
            new_unittest("lge", test_lge), &
            new_unittest("lle", test_lle), &
            new_unittest("trim", test_trim), &
            new_unittest("len", test_len), &
            new_unittest("len_trim", test_len_trim), &
            new_unittest("adjustl", test_adjustl), &
            new_unittest("adjustr", test_adjustr), &
            new_unittest("scan", test_scan), &
            new_unittest("verify", test_verify), &
            new_unittest("repeat", test_repeat), &
            new_unittest("index", test_index), &
            new_unittest("char", test_char), &
            new_unittest("ichar", test_ichar), &
            new_unittest("iachar", test_iachar), &
            new_unittest("move", test_move) &
            ]
    end subroutine collect_string_intrinsic

    !> Generate then checker both for the string type created from the character
    !> sequence by the contructor and the assignment operation
    subroutine check1(error, chr1, checker)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        character(len=*), intent(in) :: chr1
        procedure(check1_interface) :: checker
        call constructor_check1(error, chr1, checker)
        if (allocated(error)) return
        call assignment_check1(error, chr1, checker)
    end subroutine check1

    !> Run the actual checker with a string type generated by the custom constructor
    subroutine constructor_check1(error, chr1, checker)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        character(len=*), intent(in) :: chr1
        procedure(check1_interface) :: checker
        call checker(error, construct_string_type(chr1), chr1)
    end subroutine constructor_check1

    !> Run the actual checker with a string type generated by assignment
    subroutine assignment_check1(error, chr1, checker)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        character(len=*), intent(in) :: chr1
        type(string_type) :: str1
        procedure(check1_interface) :: checker
        str1 = chr1
        call checker(error, str1, chr1)
    end subroutine assignment_check1

    !> Generate then checker both for the string type created from the character
    !> sequence by the contructor and the assignment operation as well as the
    !> mixed assigment and constructor setup
    subroutine check2(error, chr1, chr2, checker)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        character(len=*), intent(in) :: chr1, chr2
        procedure(check2_interface) :: checker
        call constructor_check2(error, chr1, chr2, checker)
        if (allocated(error)) return
        call assignment_check2(error, chr1, chr2, checker)
        if (allocated(error)) return
        call mixed_check2(error, chr1, chr2, checker)
    end subroutine check2

    !> Run the actual checker with both string types generated by the custom constructor
    subroutine constructor_check2(error, chr1, chr2, checker)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        character(len=*), intent(in) :: chr1, chr2
        procedure(check2_interface) :: checker
        call checker(error, construct_string_type(chr1), chr1, construct_string_type(chr2), chr2)
    end subroutine constructor_check2

    !> Run the actual checker with one string type generated by the custom constructor
    !> and the other by assignment
    subroutine mixed_check2(error, chr1, chr2, checker)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        character(len=*), intent(in) :: chr1, chr2
        type(string_type) :: str1, str2
        procedure(check2_interface) :: checker
        str1 = chr1
        str2 = chr2
        call checker(error, str1, chr1, construct_string_type(chr2), chr2)
        if (allocated(error)) return
        call checker(error, construct_string_type(chr1), chr1, str2, chr2)
    end subroutine mixed_check2

    !> Run the actual checker with both string types generated by assignment
    subroutine assignment_check2(error, chr1, chr2, checker)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        character(len=*), intent(in) :: chr1, chr2
        type(string_type) :: str1, str2
        procedure(check2_interface) :: checker
        str1 = chr1
        str2 = chr2
        call checker(error, str1, chr1, str2, chr2)
    end subroutine assignment_check2

    !> Generator for checking the lexical comparison
    subroutine gen_lgt(error, str1, chr1, str2, chr2)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        type(string_type), intent(in) :: str1, str2
        character(len=*), intent(in) :: chr1, chr2
        logical :: res1, res2, res3
        res1 = lgt(str1, str2)
        res2 = lgt(str1, chr2)
        res3 = lgt(chr1, str2)
        call check(error, res1 .eqv. lgt(chr1, chr2))
        if (allocated(error)) return
        call check(error, res2 .eqv. lgt(chr1, chr2))
        if (allocated(error)) return
        call check(error, res3 .eqv. lgt(chr1, chr2))
    end subroutine gen_lgt

    subroutine test_lgt(error)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error

        type(string_type) :: string
        logical :: res

        string = "bcd"
        res = lgt(string, "abc")
        call check(error, res .eqv. .true.)
        if (allocated(error)) return

        res = lgt(string, "bcd")
        call check(error, res .eqv. .false.)
        if (allocated(error)) return

        res = lgt(string, "cde")
        call check(error, res .eqv. .false.)
        if (allocated(error)) return

        call check2(error, "bcd", "abc", gen_lgt)
        if (allocated(error)) return
        call check2(error, "bcd", "bcd", gen_lgt)
        if (allocated(error)) return
        call check2(error, "bcd", "cde", gen_lgt)
    end subroutine test_lgt

    !> Generator for checking the lexical comparison
    subroutine gen_llt(error, str1, chr1, str2, chr2)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        type(string_type), intent(in) :: str1, str2
        character(len=*), intent(in) :: chr1, chr2
        logical :: res1, res2, res3
        res1 = llt(str1, str2)
        res2 = llt(str1, chr2)
        res3 = llt(chr1, str2)
        call check(error, res1 .eqv. llt(chr1, chr2))
        if (allocated(error)) return
        call check(error, res2 .eqv. llt(chr1, chr2))
        if (allocated(error)) return
        call check(error, res3 .eqv. llt(chr1, chr2))
    end subroutine gen_llt

    subroutine test_llt(error)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error

        type(string_type) :: string
        logical :: res

        string = "bcd"
        res = llt(string, "abc")
        call check(error, res .eqv. .false.)
        if (allocated(error)) return

        res = llt(string, "bcd")
        call check(error, res .eqv. .false.)
        if (allocated(error)) return

        res = llt(string, "cde")
        call check(error, res .eqv. .true.)
        if (allocated(error)) return

        call check2(error, "bcd", "abc", gen_llt)
        if (allocated(error)) return
        call check2(error, "bcd", "bcd", gen_llt)
        if (allocated(error)) return
        call check2(error, "bcd", "cde", gen_llt)
    end subroutine test_llt

    !> Generator for checking the lexical comparison
    subroutine gen_lge(error, str1, chr1, str2, chr2)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        type(string_type), intent(in) :: str1, str2
        character(len=*), intent(in) :: chr1, chr2
        logical :: res1, res2, res3
        res1 = lge(str1, str2)
        res2 = lge(str1, chr2)
        res3 = lge(chr1, str2)
        call check(error, res1 .eqv. lge(chr1, chr2))
        if (allocated(error)) return
        call check(error, res2 .eqv. lge(chr1, chr2))
        if (allocated(error)) return
        call check(error, res3 .eqv. lge(chr1, chr2))
    end subroutine gen_lge

    subroutine test_lge(error)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error

        type(string_type) :: string
        logical :: res

        string = "bcd"
        res = lge(string, "abc")
        call check(error, res .eqv. .true.)
        if (allocated(error)) return

        res = lge(string, "bcd")
        call check(error, res .eqv. .true.)
        if (allocated(error)) return

        res = lge(string, "cde")
        call check(error, res .eqv. .false.)
        if (allocated(error)) return

        call check2(error, "bcd", "abc", gen_lge)
        if (allocated(error)) return
        call check2(error, "bcd", "bcd", gen_lge)
        if (allocated(error)) return
        call check2(error, "bcd", "cde", gen_lge)
    end subroutine test_lge

    !> Generator for checking the lexical comparison
    subroutine gen_lle(error, str1, chr1, str2, chr2)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        type(string_type), intent(in) :: str1, str2
        character(len=*), intent(in) :: chr1, chr2
        logical :: res1, res2, res3
        res1 = lle(str1, str2)
        res2 = lle(str1, chr2)
        res3 = lle(chr1, str2)
        call check(error, res1 .eqv. lle(chr1, chr2))
        if (allocated(error)) return
        call check(error, res2 .eqv. lle(chr1, chr2))
        if (allocated(error)) return
        call check(error, res3 .eqv. lle(chr1, chr2))
    end subroutine gen_lle

    subroutine test_lle(error)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error

        type(string_type) :: string
        logical :: res

        string = "bcd"
        res = lle(string, "abc")
        call check(error, res .eqv. .false.)
        if (allocated(error)) return

        res = lle(string, "bcd")
        call check(error, res .eqv. .true.)
        if (allocated(error)) return

        res = lle(string, "cde")
        call check(error, res .eqv. .true.)
        if (allocated(error)) return

        call check2(error, "bcd", "abc", gen_lle)
        if (allocated(error)) return
        call check2(error, "bcd", "bcd", gen_lle)
        if (allocated(error)) return
        call check2(error, "bcd", "cde", gen_lle)
    end subroutine test_lle

    !> Generator for checking the trimming of whitespace
    subroutine gen_trim(error, str1, chr1)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        type(string_type), intent(in) :: str1
        character(len=*), intent(in) :: chr1
        call check(error, len(trim(str1)) == len(trim(chr1)))
    end subroutine gen_trim

    subroutine test_trim(error)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error

       type(string_type) :: string, trimmed_str

       string = "Whitespace                            "
       trimmed_str = trim(string)
       call check(error, len(trimmed_str) == 10)
       if (allocated(error)) return

       call check1(error, " Whitespace  ", gen_trim)
       if (allocated(error)) return
       call check1(error, " W h i t e s p a ce  ", gen_trim)
       if (allocated(error)) return
       call check1(error, "SPACE    SPACE", gen_trim)
       if (allocated(error)) return
       call check1(error, "                           ", gen_trim)
    end subroutine test_trim

    !> Generator for checking the length of the character sequence
    subroutine gen_len(error, str1, chr1)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        type(string_type), intent(in) :: str1
        character(len=*), intent(in) :: chr1
        call check(error, len(str1) == len(chr1))
    end subroutine gen_len

    subroutine test_len(error)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error

        type(string_type) :: string
        integer :: length

        string = "Some longer sentence for this example."
        length = len(string)
        call check(error, length == 38)
        if (allocated(error)) return

        string = "Whitespace                            "
        length = len(string)
        call check(error, length == 38)
        if (allocated(error)) return

        call check1(error, "Example string", gen_len)
        if (allocated(error)) return
        call check1(error, "S P A C E D   S T R I N G", gen_len)
        if (allocated(error)) return
        call check1(error, "With trailing whitespace               ", gen_len)
        if (allocated(error)) return
        call check1(error, "     centered      ", gen_len)
    end subroutine test_len

    !> Generator for checking the length of the character sequence without whitespace
    subroutine gen_len_trim(error, str1, chr1)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        type(string_type), intent(in) :: str1
        character(len=*), intent(in) :: chr1
        call check(error, len_trim(str1) == len_trim(chr1))
    end subroutine gen_len_trim

    subroutine test_len_trim(error)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error

        type(string_type) :: string
        integer :: length

        string = "Some longer sentence for this example."
        length = len_trim(string)
        call check(error, length == 38)
        if (allocated(error)) return

        string = "Whitespace                            "
        length = len_trim(string)
        call check(error, length == 10)
        if (allocated(error)) return

        call check1(error, "Example string", gen_len_trim)
        if (allocated(error)) return
        call check1(error, "S P A C E D   S T R I N G", gen_len_trim)
        if (allocated(error)) return
        call check1(error, "With trailing whitespace               ", gen_len_trim)
        if (allocated(error)) return
        call check1(error, "     centered      ", gen_len_trim)
    end subroutine test_len_trim

    !> Generator for checking the left adjustment of the character sequence
    subroutine gen_adjustl(error, str1, chr1)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        type(string_type), intent(in) :: str1
        character(len=*), intent(in) :: chr1
        call check(error, adjustl(str1) == adjustl(chr1))
    end subroutine gen_adjustl

    subroutine test_adjustl(error)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error

        type(string_type) :: string

        string = "                            Whitespace"
        string = adjustl(string)
        call check(error, char(string) == "Whitespace                            ")
        if (allocated(error)) return

        call check1(error, "           B L A N K S        ", gen_adjustl)
    end subroutine test_adjustl

    !> Generator for checking the right adjustment of the character sequence
    subroutine gen_adjustr(error, str1, chr1)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        type(string_type), intent(in) :: str1
        character(len=*), intent(in) :: chr1
        call check(error, adjustr(str1) == adjustr(chr1))
    end subroutine gen_adjustr

    subroutine test_adjustr(error)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error

        type(string_type) :: string

        string = "Whitespace                            "
        string = adjustr(string)
        call check(error, char(string) == "                            Whitespace")
        if (allocated(error)) return

        call check1(error, "           B L A N K S        ", gen_adjustr)
    end subroutine test_adjustr

    !> Generator for checking the presence of a character set in a character sequence
    subroutine gen_scan(error, str1, chr1, str2, chr2)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        type(string_type), intent(in) :: str1, str2
        character(len=*), intent(in) :: chr1, chr2
        call check(error, scan(str1, str2) == scan(chr1, chr2))
        if (allocated(error)) return
        call check(error, scan(str1, chr2) == scan(chr1, chr2))
        if (allocated(error)) return
        call check(error, scan(chr1, str2) == scan(chr1, chr2))
        if (allocated(error)) return
        call check(error, scan(str1, str2, back=.true.) == scan(chr1, chr2, back=.true.))
        if (allocated(error)) return
        call check(error, scan(str1, chr2, back=.true.) == scan(chr1, chr2, back=.true.))
        if (allocated(error)) return
        call check(error, scan(chr1, str2, back=.true.) == scan(chr1, chr2, back=.true.))
    end subroutine gen_scan

    subroutine test_scan(error)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error

        type(string_type) :: string
        integer :: pos

        string = "fortran"
        pos = scan(string, "ao")
        call check(error, pos == 2)
        if (allocated(error)) return

        pos = scan(string, "ao", .true.)
        call check(error, pos == 6)
        if (allocated(error)) return

        pos = scan(string, "c++")
        call check(error, pos == 0)
        if (allocated(error)) return

        call check2(error, "fortran", "ao", gen_scan)
        if (allocated(error)) return
        call check2(error, "c++", "fortran", gen_scan)

    end subroutine test_scan

    !> Generator for checking the absence of a character set in a character sequence
    subroutine gen_verify(error, str1, chr1, str2, chr2)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        type(string_type), intent(in) :: str1, str2
        character(len=*), intent(in) :: chr1, chr2
        call check(error, verify(str1, str2) == verify(chr1, chr2))
        if (allocated(error)) return
        call check(error, verify(str1, chr2) == verify(chr1, chr2))
        if (allocated(error)) return
        call check(error, verify(chr1, str2) == verify(chr1, chr2))
        if (allocated(error)) return
        call check(error, verify(str1, str2, back=.true.) == verify(chr1, chr2, back=.true.))
        if (allocated(error)) return
        call check(error, verify(str1, chr2, back=.true.) == verify(chr1, chr2, back=.true.))
        if (allocated(error)) return
        call check(error, verify(chr1, str2, back=.true.) == verify(chr1, chr2, back=.true.))
    end subroutine gen_verify

    subroutine test_verify(error)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error

        type(string_type) :: string
        integer :: pos

        string = "fortran"
        pos = verify(string, "ao")
        call check(error, pos == 1)
        if (allocated(error)) return

        pos = verify(string, "fo")
        call check(error, pos == 3)
        if (allocated(error)) return

        pos = verify(string, "c++")
        call check(error, pos == 1)
        if (allocated(error)) return

        pos = verify(string, "c++", back=.true.)
        call check(error, pos == 7)
        if (allocated(error)) return

        pos = verify(string, string)
        call check(error, pos == 0)
        if (allocated(error)) return

        call check2(error, "fortran", "ao", gen_verify)
        if (allocated(error)) return
        call check2(error, "c++", "fortran", gen_verify)

    end subroutine test_verify

    !> Generator for the repeatition of a character sequence
    subroutine gen_repeat(error, str1, chr1)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        type(string_type), intent(in) :: str1
        character(len=*), intent(in) :: chr1
        integer :: i
        do i = 12, 3, -2
            call check(error, repeat(str1, i) == repeat(chr1, i))
            if (allocated(error)) return
        end do
    end subroutine gen_repeat

    subroutine test_repeat(error)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error

        type(string_type) :: string

        string = "What? "
        string = repeat(string, 3)
        call check(error, string == "What? What? What? ")
        if (allocated(error)) return

        ! call check1(error, "!!1!", gen_repeat)
        ! if (allocated(error)) return
        ! call check1(error, "This sentence is repeated multiple times. ", gen_repeat)

    end subroutine test_repeat

    !> Generator for checking the substring search in a character string
    subroutine gen_index(error, str1, chr1, str2, chr2)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        type(string_type), intent(in) :: str1, str2
        character(len=*), intent(in) :: chr1, chr2
        integer :: pos1, pos2, pos3, pos4, pos5, pos6
        pos1 = index(str1, str2)
        pos2 = index(str1, chr2)
        pos3 = index(chr1, str2)
        pos4 = index(str1, str2, back=.true.)
        pos5 = index(str1, chr2, back=.true.)
        pos6 = index(chr1, str2, back=.true.)
        call check(error, pos1 == index(chr1, chr2))
        if (allocated(error)) return
        call check(error, pos2 == index(chr1, chr2))
        if (allocated(error)) return
        call check(error, pos3 == index(chr1, chr2))
        if (allocated(error)) return
        call check(error, pos4 == index(chr1, chr2, back=.true.))
        if (allocated(error)) return
        call check(error, pos5 == index(chr1, chr2, back=.true.))
        if (allocated(error)) return
        call check(error, pos6 == index(chr1, chr2, back=.true.))
    end subroutine gen_index

    subroutine test_index(error)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error

        type(string_type) :: string
        integer :: pos

        string = "Search this string for this expression"
        pos = index(string, "this")
        call check(error, pos == 8)
        if (allocated(error)) return

        pos = index(string, "this", back=.true.)
        call check(error, pos == 24)
        if (allocated(error)) return

        pos = index(string, "This")
        call check(error, pos == 0)
        if (allocated(error)) return

        call check2(error, "Search this string for this expression", "this", gen_index)
        if (allocated(error)) return
        call check2(error, "Search this string for this expression", "This", gen_index)

    end subroutine test_index

    subroutine test_char(error)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error

        type(string_type) :: string
        character(len=:), allocatable :: dlc
        character(len=1), allocatable :: chars(:)

        string = "Character sequence"
        dlc = char(string)
        call check(error, dlc == "Character sequence")
        if (allocated(error)) return

        dlc = char(string, 3)
        call check(error, dlc == "a")
        if (allocated(error)) return
        chars = char(string, [3, 5, 8, 12, 14, 15, 18])
        call check(error, all(chars == ["a", "a", "e", "e", "u", "e", "e"]))
        if (allocated(error)) return

        string = "Fortran"
        dlc = char(string, 1, 4)
        call check(error, dlc == "Fort")
    end subroutine test_char

    subroutine test_ichar(error)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error

        type(string_type) :: string
        integer :: code

        string = "Fortran"
        code = ichar(string)
        call check(error, code == ichar("F"))
    end subroutine test_ichar

    subroutine test_iachar(error)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error

        type(string_type) :: string
        integer :: code

        string = "Fortran"
        code = iachar(string)
        call check(error, code == iachar("F"))
    end subroutine test_iachar

    subroutine test_move(error)
        !> Error handling
        type(error_type), allocatable, intent(out) :: error
        type(string_type) :: from_string, to_string
        type(string_type) :: from_string_not
        ! type(string_type) :: from_strings(2), to_strings(2)
        character(len=:), allocatable :: from_char, to_char

        from_string = "Move This String"
        ! from_strings = "Move This String"
        from_char = "Move This Char"
        call check(error, from_string == "Move This String" .and. to_string == "" .and. &
            & from_char == "Move This Char" .and. .not. allocated(to_char), &
            & "move: test_case 1")
        if (allocated(error)) return

        ! string_type (allocated) --> string_type (not allocated)
        call move(from_string, to_string)
        call check(error, from_string == "" .and. to_string == "Move This String", "move: test_case 2")
        if (allocated(error)) return

        ! character (allocated) --> string_type (not allocated)
        call move(from_char, from_string)
        call check(error, .not. allocated(from_char) .and. from_string == "Move This Char", &
            & "move: test_case 3")
        if (allocated(error)) return

        ! string_type (allocated) --> character (not allocated)
        call move(to_string, to_char)
        call check(error, to_string == "" .and. to_char == "Move This String", "move: test_case 4")
        if (allocated(error)) return

        ! character (allocated) --> string_type (allocated)
        call move(to_char, from_string)
        call check(error, .not. allocated(to_char) .and. from_string == "Move This String", &
            & "move: test_case 5")
        if (allocated(error)) return

        from_char = "new char"
        ! character (allocated) --> string_type (allocated)
        call move(from_char, from_string)
        call check(error, .not. allocated(from_char) .and. from_string == "new char", "move: test_case 6")
        if (allocated(error)) return

        ! character (not allocated) --> string_type (allocated)
        call move(from_char, from_string)
        call check(error, from_string == "", "move: test_case 7")
        if (allocated(error)) return

        from_string = "moving to self"
        ! string_type (allocated) --> string_type (allocated)
        ! call move(from_string, from_string)
        ! call check(error, from_string == "moving to self", "move: test_case 8")
        ! if (allocated(error)) return

        ! elemental: string_type (allocated) --> string_type (not allocated)
        ! call move(from_strings, to_strings)
        ! call check(error, all(from_strings(:) == "") .and. all(to_strings(:) == "Move This String"), "move: test_case 9")

        ! string_type (not allocated) --> string_type (not allocated)
        call move(from_string_not, to_string)
        call check(error, from_string_not == "" .and. to_string == "", "move: test_case 10")
        if (allocated(error)) return

        ! string_type (not allocated) --> string_type (not allocated)
        to_string = "to be deallocated"
        call move(from_string_not, to_string)
        call check(error, from_string_not == "" .and. to_string == "", "move: test_case 11")
        if (allocated(error)) return

    end subroutine test_move

end module test_string_intrinsic


program tester
    use, intrinsic :: iso_fortran_env, only : error_unit
    use testdrive, only : run_testsuite, new_testsuite, testsuite_type
    use test_string_intrinsic, only : collect_string_intrinsic
    implicit none
    integer :: stat, is
    type(testsuite_type), allocatable :: testsuites(:)
    character(len=*), parameter :: fmt = '("#", *(1x, a))'

    stat = 0

    testsuites = [ &
        new_testsuite("string-intrinsic", collect_string_intrinsic) &
        ]

    do is = 1, size(testsuites)
        write(error_unit, fmt) "Testing:", testsuites(is)%name
        call run_testsuite(testsuites(is)%collect, error_unit, stat)
    end do

    if (stat > 0) then
        write(error_unit, '(i0, 1x, a)') stat, "test(s) failed!"
        error stop
    end if
end program
