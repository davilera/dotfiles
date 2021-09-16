export type SetValue = {
	readonly type: 'SET_VALUE';
	readonly value: string;
};

export type Next = {
	readonly type: 'NEXT';
};

export type Back = {
	readonly type: 'BACK';
};
