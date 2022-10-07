#include<stdio.h>
#include<stdbool.h>

void swap(int *x, int *y){
    int temp = *x;
    *x = *y;
    *y = temp;
}

void heapify(int *nums, int i, int numsSize){    
    int currValue = nums[i];
    int j = i * 2 + 1; // left child
    int parent;
    
    while (j < numsSize){      
        if (j < (numsSize - 1)){
            if (nums[j] < nums[j + 1]){
                j = j + 1;
            }
        }
        
        if (currValue >= nums[j])
            break;
        else{
            if (j % 2 == 0)
                parent = j / 2 - 1;
            else
                parent = j / 2;
            nums[parent] = nums[j];
            j = j * 2 + 1;
        }
    }
    
    if (j % 2 == 0)
        parent = j / 2 - 1;
    else
        parent = j / 2;
    nums[parent] = currValue;
}

void heapSort(int *nums, int numsSize){
    for (int i = numsSize / 2 - 1; i >= 0; i--){
        heapify(nums, i, numsSize);
    }
    
    for (int i = numsSize - 1; i >= 0; i--){
        swap(&nums[0], &nums[i]);
        heapify(nums, 0, i);
    }
}

bool containsDuplicate(int* nums, int numsSize){
    heapSort(nums, numsSize);
    
    for (int i = 0; i < numsSize - 1; i++){
        if (nums[i] == nums[i + 1])
            return true;
    }
    
    return false;
}

int main(){
	int question1[] = {1, 4, 5, 6, 2, 3};
	bool answer1 = false;
	printf("Question1 ");
	if (answer1 == containsDuplicate(question1, (sizeof(question1)/sizeof(question1[0]))))
		printf("Accepted\n");
	else
		printf("Failed\n");

	int question2[] = {3, 2, 1, 4, 2, 1};
	bool answer2 = true;
	printf("Question2 ");
	if (answer2 == containsDuplicate(question2, (sizeof(question2)/sizeof(question2[0]))))
		printf("Accepted\n");
	else
		printf("Failed\n");


	int question3[] = {-1, -2, 3, 4, -2, -1};
	bool answer3 = true;
	printf("Question3 ");
	if (answer3 == containsDuplicate(question3, (sizeof(question3)/sizeof(question3[0]))))
		printf("Accepted\n");
	else
		printf("Failed\n");

	return 0;
}
