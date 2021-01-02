//207237421 Yael Avioz

#include <stdio.h>
#include <string.h>

#define OPTION_ONE 3
#define OPTION_TWO 5
#define OPTION_THREE 6
#define SRC_FILE_INDEX 1
#define DEST_FILE_INDEX 2
#define SRC_OS_FLAG 3
#define DEST_OS_FLAG 4
#define ENDIENESS_FLAG 5
#define UTF_16_CHAR_SIZE 2

/* This function checks if a UTF-16 given file is big endian or little endian by the BOM
   Input: char *file_name - this is the name of the file we want to check 
   Output: 1 - if the file is little endian, 0 - if is big endian and -1 if there was an error
*/
int is_big_endian(char *file_name)
{
    char data[2];
    size_t nbytes;
    // Open file in binary mode
    FILE *file = fopen(file_name, "rb");

    // File open error
    if (file == NULL)
    {
        return -1;
    }

    // Read BOM from file
    if (fread(data, UTF_16_CHAR_SIZE, 1, file))
    {
        // Checks if the BOM is encoding big endian
        if ((data[0] == (char)0xFE) && (data[1] == (char)0xFF))
        {
            return 0;
        }
    }
    // Error reading BOM in the file
    else
    {
        return -1;
    }
    
    return 1;
}

/* This function write the data to the destination file acording to the requested endianess
   The function write the the data to a new file according to the flag of should_swap_byte_order
   Input: char *data - representation of one char encoding in UTF-16
		  FILE *dest_file - the destination file
		  int should_swap_byte_order - if should_swap_byte_order == 0 it means dont swap the data, else swap
   Output: none 
*/
void write_data_by_endianess(char *data, FILE *dest_file, int should_swap_byte_order)
{
    // swich the order of the bytes.
    char tmp;
    // In case should swap the byte order swap them
    if (should_swap_byte_order)
    {
        tmp = data[0];
        data[0] = data[1];
        data[1] = tmp;
    }
    // Write the data to the new file
    fwrite(data, UTF_16_CHAR_SIZE, 1, dest_file);
}

/* The function gets source and destination file names and copy the source file data to the destination file
	Input: char *src_file_name - the source file name
		   char *dest_file_name - the destination file name
	Output: -1 in case thers is an error reading the files, 0 - if the copy process succeeded
*/
int copy_file(char *src_file_name, char *dest_file_name)
{
    FILE *src, *dest;
    char data[UTF_16_CHAR_SIZE];
    // Open src and dest files in binary mode
    src = fopen(src_file_name, "rb");
    // Error opening file
    if (src == NULL)
    {
        return -1;
    }
    dest = fopen(dest_file_name, "wb");
    // Error opening file
    if (dest == NULL)
    {
        return -1;
    }

    // Read 2-byte char from src file and write to dest file char by char.
    while (fread(data, UTF_16_CHAR_SIZE, 1, src))
    {
        fwrite(data, UTF_16_CHAR_SIZE, 1, dest);
    }

    // Close src and dest files.
    fclose(src);
    fclose(dest);

    return 0;
}

/* Get a file matching one of the operation systems windows, unix or mac and convert it to the requested system.
   The function read the file char by char and search for the match newline signs to the given operation system in the text
   In case the function found a correct newline sign it will swich him to the newline of the requested operation system
   Also, the function swich the byte order if we requested to do it - by using the function "write_data_by_endianess"
   Input: char *src_file_name - the source file name
		  char *dest_file_name - the destination file name
		  char *src_os - the source operation system
		  char *dest_os - the destination operation system
		  char *byte_order - keep or swap the byte order
	Output: -1 in case thers is an error reading the files, 0 - if the convert process succeeded
*/
int convert_file(char *src_file_name, char *dest_file_name, char *src_os, char *dest_os, char *byte_order)
{
    FILE *src, *dest;
    char data[UTF_16_CHAR_SIZE];
    char *src_newline, *dest_newline, *src_win_newline;

	// Compere the given byte order string with keep - in case strcmp = 0 keep the byte order as is  
    int should_swap_byte_order = strcmp(byte_order, "-keep");

	// Set the is_big_endian_dest_newline, this prameter is 1 - if the destination newline should be representing in big endian
	// or 0 if the destination newline should be representing in little endian
    int is_big_endian_dest_newline = ((is_big_endian(src_file_name) == 0) && (should_swap_byte_order == 0)) ||
                                    ((is_big_endian(src_file_name) == 1) && (should_swap_byte_order != 0));

	// This is the size of bytes that destination newline takes
    int dest_newline_size;

    // Checks if the os flag is unix
    if (strcmp(dest_os, "-unix") == 0)
    {
        dest_newline_size = UTF_16_CHAR_SIZE;

        // Set the dest_newline according to the endianness
        if (is_big_endian_dest_newline)
        {
            // Big endian
            dest_newline = "\x00\x0A";
        }
        else
        {
            // Little endian
            dest_newline = "\x0A\x00";
        }
    }

    // Checks if the os flag is mac
    else if (strcmp(dest_os, "-mac") == 0)
    {
        dest_newline_size = UTF_16_CHAR_SIZE;

        // Set the dest_newline according to the endianness
        if (is_big_endian_dest_newline)
        {
            // Big endian
            dest_newline = "\x00\x0D";
        }
        else
        {
            // Little endian
            dest_newline = "\x0D\x00";
        }
    }

    // Checks if the os flag is win
    else if (strcmp(dest_os, "-win") == 0)
    {
        dest_newline_size = UTF_16_CHAR_SIZE * 2;

        // Set the dest_newline according to the endianness
        if (is_big_endian_dest_newline)
        {
            // Big endian
            dest_newline = "\x00\x0D\x00\x0A";
        }
        else
        {
            // Little endian
            dest_newline = "\x0D\x00\x0A\x00";
        }
    }
    else
    {
        return -1;
    }

    // Open the source and the destination files.
    src = fopen(src_file_name, "rb");
    // Error in the file
    if (src == NULL)
    {
        return -1;
    }
    dest = fopen(dest_file_name, "wb");
    // Error in the file
    if (dest == NULL)
    {
        return -1;
    }

    if (strcmp(src_os, "-unix") == 0 || (strcmp(src_os, "-mac") == 0))
    {
        // Checks the given os flag is unix
        if (strcmp(src_os, "-unix") == 0)
        {
            // Checks if the given file is big or little endian
            if (is_big_endian(src_file_name) == 0)
            {
                // Big endian representation in utf-16 of \n
                src_newline = "\x00\x0A";
            }
            else
            {
                // Little endian representation in utf-16 of \n
                src_newline = "\x0A\x00";
            }
        }
        // Checks the given os flag is mac
        else if (strcmp(src_os, "-mac") == 0)
        {
            // Checks if the given file is big or little endian
            if (is_big_endian(src_file_name) == 0)
            {
                // Big endian representation in utf-16 of \r
                src_newline = "\x00\x0D";
            }
            else
            {
                // Little endian representation in utf-16 of \r
                src_newline = "\x0D\x00";
            }
        }

        // Read the file char by char
        while (fread(data, UTF_16_CHAR_SIZE, 1, src))
        {
            // Check if the char is a newline according to our os system
            //if (strncmp(data, src_newline, 2) == 0)
            if ((data[0] == (char)src_newline[0]) && (data[1] == (char)src_newline[1]))
            {
                // Write the dest newline in the file
                fwrite(dest_newline, dest_newline_size, 1, dest);
            }
            // If the char is not a newline char - write the data as is
            else
            {
                write_data_by_endianess(data, dest, should_swap_byte_order);
            }
        }
    }

    else if (strcmp(src_os, "-win") == 0)
    {
        // Checks if the given file is big or little endian
        if (is_big_endian(src_file_name) == 0)
        {
            // Big endian representation in utf-16 of \r\n
            src_newline = "\x00\x0D";
            src_win_newline = "\x00\x0A";
        }
        else
        {
            // Little endian representation in utf-16 of \r\n
            src_newline = "\x0D\x00";
            src_win_newline = "\x0A\x00";
        }

        // Read the file char by char
        while (fread(data, UTF_16_CHAR_SIZE, 1, src))
        {

            // If the char is a newline char
            //if (strncmp(data, src_newline, 2) == 0)
            if ((data[0] == (char)src_newline[0]) && (data[1] == (char)src_newline[1]))
            {
                // Keep reading and check the next char
                if (fread(data, UTF_16_CHAR_SIZE, 1, src))
                {
                    // If we found a win newline chars
                    //if (strncmp(data, src_win_newline, 2) == 0)
                    if ((data[0] == (char)src_win_newline[0]) && (data[1] == (char)src_win_newline[1]))
                    {
                        // Write the dest newline insted the old one
                        fwrite(dest_newline, dest_newline_size, 1, dest);
                    }
                    // In case the next char wasnt a new line - write the data as is
                    else
                    {
                        write_data_by_endianess(src_newline, dest, should_swap_byte_order);
                        write_data_by_endianess(data, dest, should_swap_byte_order);
                    }
                }
            }
            // If the data is not a newline char write it as it
            else
            {
                write_data_by_endianess(data, dest, should_swap_byte_order);
            }
        }
    }
    else
    {
        // Close src and dest files in case of error.
        fclose(src);
        fclose(dest);

        return -1;
    }

    // Close src and dest files.
    fclose(src);
    fclose(dest);

    return 0;
}

// The main function
int main(int argc, char **argv)
{
    if (argc == OPTION_ONE)
    {
        return copy_file(argv[SRC_FILE_INDEX], argv[DEST_FILE_INDEX]);
    }
	// In case the function gets only 4 arguments - we will use the function "convet_file" with the flag "keep"
    else if (argc == OPTION_TWO)
    {
        return convert_file(argv[SRC_FILE_INDEX], argv[DEST_FILE_INDEX], argv[SRC_OS_FLAG], argv[DEST_OS_FLAG], "-keep");
    }
    else if (argc == OPTION_THREE)
    {
        return convert_file(argv[SRC_FILE_INDEX], argv[DEST_FILE_INDEX], argv[SRC_OS_FLAG], argv[DEST_OS_FLAG], argv[ENDIENESS_FLAG]);
    }
    // Invalid input
    return -1;
}
