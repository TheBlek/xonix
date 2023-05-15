#include <stdlib.h>
#include "hashmap.h"


__attribute__((visibility("default")))
HashMap HM_Init(EqualFunc ef, HashFunc hf, int len){

    HashMap *new_table = (HashMap*)calloc(1, sizeof(HashMap));
    
    new_table->hf = hf;
    new_table->len = len;
    new_table->ef = ef;
    new_table->table = (node*)calloc(len, sizeof(node));
    
    return *new_table;
}


__attribute__((visibility("default")))
void HM_Set(HashMap *self, cpvoid key, cpvoid val){
   
    int i = self->hf(key) % self->len;

    while (self->table[i].key != 0) {

        if (self->ef(self->table[i].key, key)){

            self->table[i].val = val;
            self->table[i].key = key;

            return;

        }

        i = (i + 1) % self->len;

    }

    self->table[i].val = val;
    self->table[i].key = key;

}


__attribute__((visibility("default")))
void HM_Destroy (HashMap *self){

    if(!self) {

        if (!self->table){

            for(int i = 0; i < self->len; i ++){

                free(self->table[i]);

            }

            free(self->table);
            self->table = NULL;

        }

        free(self);

        self = NULL;

    }
}

__attribute__((visibility("default")))
cpvoid HM_Get (const HashMap *self, cpvoid key){

    int i = self->hf(key) % self->len;

    while (i < self->len && self->table[i].key != 0){

        if (!self->ef(self->table[i].key, key)) 
            i = (i + 1) % self->len;

        else
            return self->table[i].val;

    }

    return NULL;
}