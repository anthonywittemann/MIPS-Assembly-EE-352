data int[64][4];
randomAddresses int[1000];

int hit;        //$t8


for (auto address: randomAddresses){
	int testRow = address%64;
	for(int i=0; i < 4; i++){
		if(data[testRow][i]==address||i==3){
			if(data[testRow][i]==address){
				hit++;
			}
			for(int j=1; j<=i; j++){
				data[testRow][j] = data[testRow][j-1];
			}
			data[testRow][0] = address;
			break;
		}
	}
}
