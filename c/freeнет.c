#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

char ** board;

bool is_attacked(char ** board, int row, int col, int M, int N){

    for (int i = 0; i < M; i++) 
        if (board[i][col] == 'X' || board[row][i] == 'X') 
            return true;
        
    for (int i = 0; i < M; i++){
        for (int j = 0; j < N; j++){
            if (abs(row-i) == abs(col-j) && board[i][j] == 'X')
                return true;
        }
    }
    return false;
}

bool solve_queens(char ** board, int row, int M, int N){
    if (row >= M) 
        return true;
    
    for (int col = 0; col < N; col++){
        if (board[row][col] == '?' && !is_attacked(board, row, col, M, N)){
            board[row][col] = 'X';
            if (solve_queens(board, row+1, M, N)) 
                return true;
            
            board[row][col] = '?';
        }
    }
    return false;
}

int main(){
    
    int M, N;
    char sym;

    FILE * inp = fopen("input.txt", "r");
    FILE * out = fopen("output.txt", "w");

    fscanf(inp, "%d %d\n", &M, &N);

    board = (char **)calloc(sizeof(char *), M);

    for(int i = 0; i < M; i ++) {
        board[i] = (char *)calloc(sizeof(char), N); 

        for(int j = 0; j < N; j ++){
            fscanf(inp, "%c", &sym);
            board[i][j] = sym;
        }
        fscanf(inp, "%c", &sym);
    }

    if (solve_queens(board, 0, M, N)){
        fprintf(out, "YES\n");
        for (int i = 0; i < M; i++){
            for (int j = 0; j < N; j++){
                if(board[i][j] == '?')
                    fprintf(out, ".");
                else
                    fprintf(out, "%c", board[i][j]);
            }
            fprintf(out, "\n");
        }
    } 
    else 
        fprintf(out, "NO\n");
    
    for(int i = 0; i < M; i ++){
        free(board[i]);
    }
    free(board);

    return 0;
}