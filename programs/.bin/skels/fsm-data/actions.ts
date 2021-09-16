import { SetValue, Next, Back } from './types/actions';

export function setValue( value: string ): SetValue {
	return {
		type: 'SET_VALUE',
		value,
	};
} //end setValue()

export function next(): Next {
	return { type: 'NEXT' };
} //end next()

export function back(): Back {
	return { type: 'BACK' };
} //end back()
