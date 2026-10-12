#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    node *p1, *p2;
    p1 = head;
    p2 = head;
    
    while (p2 != NULL && p2->next != NULL) {
        p2 = p2->next->next;
        if (p2 == NULL) return 0;
        p1 = p1->next;
        if (p1 == p2)
            return 1;
    }
    return 0;
}