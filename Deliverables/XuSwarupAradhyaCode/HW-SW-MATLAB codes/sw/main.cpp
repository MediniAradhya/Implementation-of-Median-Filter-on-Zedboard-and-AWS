// Greg Stitt
// University of Florida
// main.cpp
//
// Description: This file is the software portion of the simple pipeline
// application implemented on the FPGA.


#include <iostream>
#include <cstdlib>
#include <cassert>
#include <cstring>
#include <cstdio>
#include <math.h>
#include <fstream>
#include <string>
#include <cstdlib>

#include "Board.h"
#include "Timer.h"

using namespace std;

#define ADDR_WIDTH 15
#define MAX_SIZE (1<<ADDR_WIDTH)
#define MEM_IN_ADDR 0
#define MEM_OUT_ADDR 0
#define COL_ADDR ((1<<MMAP_ADDR_WIDTH)-4)
#define GO_ADDR ((1<<MMAP_ADDR_WIDTH)-3)
#define SIZE_ADDR ((1<<MMAP_ADDR_WIDTH)-2)
#define DONE_ADDR ((1<<MMAP_ADDR_WIDTH)-1)


// function to read data from text file, for the software implementation of median filter
void SW_Read_Input_Data(int **swInput, int size, int c, char* file_in)
{
    int row = size/c;
    int column = c*4;
    std::ifstream fin;
    fin.open(file_in);

    /*if (fin.is_open()) {
        // print file:
        std::cout << "opening file";
    }
    else {
        // show message:
        std::cout << "Error opening file";
    }*/


    for(int i=0; i<row; i++)
    {
        for(int j=0; j<column; j++)
        {
            fin >> swInput[i][j];
            //cout << i<<" "<<j<<" "<<swInput[i][j] << endl;
        }
    }
    fin.close();
}


// software based median filter algorithm
void SW_Median(int **swInput, int **swOutput, int size, int c)
{
    int row = size/c;
    int column = c*4;
    int window[9];
//cout << "in median" << endl;
    for(int i=1; i<row-1; i++)
    {
        for(int j=1; j<column-1; j++)
        {
            window[0] = swInput[i - 1][j - 1];
            window[1] = swInput[i][j - 1];
            window[2] = swInput[i + 1][j - 1];
            window[3] = swInput[i - 1][j];
            window[4] = swInput[i][j];
            window[5] = swInput[i + 1][j];
            window[6] = swInput[i - 1][j + 1];
            window[7] = swInput[i][j + 1];
            window[8] = swInput[i + 1][j + 1];


            for(int m = 1; m < 9; ++m){
                int n = m - 1;
                int key = window[m];
                while(n >= 0 && window[n] > key){
                    window[n+1] = window[n];
                    --n;
                }
                window[n+1] = key;
            }

            swOutput[i-1][j-1] = window[4];
        }
    }
}


// function to write software based median filter output to file
void SW_Write_Output_Data(int **output, int size, int c)
{
    int row = size/c;
    int column = c*4;
    ofstream fout;
    fout.open("sw_out.txt", ios::out | ios::trunc);
    cout << "sw" << endl;
    /*if (fout.is_open()) {
        // print file:
        std::cout << "opening sw out file";
    }
    else {
        // show message:
        std::cout << "Error opening file";
    }*/
    for(int i=0; i<row-2; i++)
        for(int j=0; j<column-2; j++)
        {
            fout << output[j][i]<<endl;
            //cout << "writing" << endl;
            //cout<<output[i][j]<<endl;
        }
    fout.close();
}

// function to read data from text file, for the FPGA implementation of canny edge detection algorithm
void HW_Read_Input_Data(unsigned *dataInput, int size, char* file_in)
{
    ifstream fin;
    fin.open(file_in);
    /*if (fin.is_open()) {
        // print file:
        std::cout << "opening hw file";
    }
    else {
        // show message:
        std::cout << "Error opening file";
    }*/
    //cout << "hw in" << endl;
    for(int i=0; i<size*4; i++)
    {
        fin >> dataInput[i];
    }
    fin.close();
}


// function to convert data to words
void HW_Data_To_Words(unsigned *dataInput, unsigned *hwInput, unsigned size)
{
    //cout << "data to word" << endl;
    for (unsigned i=0, j=0; j<size*4; i++, j+=4)
    {
        // pack 4 8-bit words into one 32-bit words
        hwInput[i] = ((dataInput[j]) & 0xff) << 24 |
                     ((dataInput[j+1]) & 0xff) << 16 |
                     ((dataInput[j+2]) & 0xff) << 8 |
                     ((dataInput[j+3]) & 0xff);
    }
}

// function to convert words to data
void HW_Words_To_Data(unsigned *hwOutput, unsigned *dataOutput, unsigned size, unsigned c)
{
    unsigned row = size/c;
    unsigned column = c*4;
    cout << "hw" << endl;
    for (unsigned i=0, j=0; i<size; i++, j+=4)
    {
        dataOutput[j] = (hwOutput[i] >> 24) & 0xff;
        dataOutput[j+1] = (hwOutput[i] >> 16) & 0xff;
        dataOutput[j+2] = (hwOutput[i] >> 8) & 0xff;
        dataOutput[j+3] = (hwOutput[i]) & 0xff;
    }

    //ofstream fout;
    //fout.open("/home2/aswarup/project/hw_out.txt",ios::in | ios::out | ios::trunc);
    /*if (fout.is_open()) {
        // print file:
        std::cout << "opening hwout file";
    }
    else {
        // show message:
        std::cout << "Error opening file";
    }*/

    for(unsigned j=0; j<column; j++){
        for(unsigned i=0; i<row; i++)
        {
            //fout << dataOutput[i]<<" ";
            cout<<dataOutput[i*column+j]<<" ";
        }
        cout<<endl;
    }
    //fout.close();
}

/*
// check if hardware and software outputs match
void Check_HW_SW_Output(unsigned dataOutput[128*124], int swOutput[124][124])
{
    int k = 0;
    for(int i=0; i<124; i++)
    {
        for(int j=0; j<124; j++)
        {
            if(dataOutput[k++] != (unsigned)swOutput[i][j])
            {
                cout<<"Error: HW - SW output mismatch!"<<endl;
                return;
            }
        }
    }
    cout<<"HW - SW outputs match!"<<endl;
}*/


// main
int main(int argc, char* argv[])
{

    if (argc != 5)
    {
        cerr << "Usage: " << argv[0] << " bitfile size column file_in" << endl;
        return -1;
    }

    // setup clock frequencies
    vector<float> clocks(Board::NUM_FPGA_CLOCKS);
    clocks[0] = 100.0;
    clocks[1] = 0.0;
    clocks[2] = 0.0;
    clocks[3] = 0.0;

    // initialize board
    Board *board;
    try
    {
        board = new Board(argv[1], clocks);
    }
    catch(...)
    {
        cout<<"Could not initialize clock frequencies... Exiting!"<<endl;
        exit(-1);
    }


    /*
     * hardware implementation
     */
    unsigned size = std::atoi(argv[2]);
    unsigned column = std::atoi(argv[3]);
    unsigned go, done;
    unsigned *dataInput, *hwInput, *hwOutput, *dataOutput;
    Timer hwTime, readTime, writeTime, waitTime;

    dataInput = new unsigned[size*4];
    hwInput = new unsigned[size];
    hwOutput = new unsigned[size];
    dataOutput = new unsigned[size*4+1];
    
    char* filename = argv[4];

    // transfer words and size to FPGA
    HW_Read_Input_Data(dataInput,size, filename);
    HW_Data_To_Words(dataInput, hwInput,size);
    hwTime.start();
    writeTime.start();
    board->write(hwInput, MEM_IN_ADDR, size);
    board->write(&size, SIZE_ADDR, 1);
    board->write(&column, COL_ADDR, 1);
    writeTime.stop();

    // assert go. Note that the memory map automatically sets go back to 1 to
    // avoid an additional transfer.
    go = 1;
    board->write(&go, GO_ADDR, 1);

    // wait for the board to assert done
    waitTime.start();
    done = 0;
    while (!done)
    {
        board->read(&done, DONE_ADDR, 1);
    }
    waitTime.stop();

    // read the outputs back from the FPGA
    readTime.start();
    board->read(hwOutput, MEM_OUT_ADDR, size);
    readTime.stop();
    hwTime.stop();
    HW_Words_To_Data(hwOutput, dataOutput, size, column);

    /*
    * software implementation
    */
    int **swInput;
    int **swOutput;
    Timer swTime;
    swInput = new int*[column*4];
    for(unsigned i=0;i<column*4;i++){
        swInput[i] = new int[size/column];
    }
    swOutput = new int*[column*4];
    for(unsigned i=0;i<column*4;i++){
        swOutput[i] = new int[size/column];
    }

    SW_Read_Input_Data(swInput,size,column, filename);
    swTime.start();
    SW_Median(swInput, swOutput,size,column);
    swTime.stop();
    SW_Write_Output_Data(swOutput,size,column);
/*
    delete[] dataInput;
    delete[] hwInput;
    delete[] hwOutput;
    delete[] dataOutput;

    for(unsigned i=0;i<column*4;i++){
        delete[] swInput[i];
    }
    delete[] swInput;

    for(unsigned i=0;i<column*4;i++){
        delete[] swOutput[i];
    }
    delete[] swOutput;
*/


    /*
     * check if hardware and software outputs match
     * -- should not match due to use of approximate methods in hardware implementation
     */
    //Check_HW_SW_Output(dataOutput, swOutput);


    /*
     *  calculate speedup
     */
    double transferTime = writeTime.elapsedTime() + readTime.elapsedTime();
    double hwTimeNoTransfer = hwTime.elapsedTime() - transferTime;
    cout << "Speedup: " << swTime.elapsedTime()/hwTime.elapsedTime() << endl;
    cout << "Speedup (no transfers): " << swTime.elapsedTime()/hwTimeNoTransfer << endl;
}
