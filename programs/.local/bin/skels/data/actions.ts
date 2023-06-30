export type Action = SetValue;

export type SetValue = {
	readonly type: 'SET_VALUE';
	readonly value: string;
};

export function setValue( value: string ): SetValue {
	return {
		type: 'SET_VALUE',
		value,
	};
} //end setValue()
