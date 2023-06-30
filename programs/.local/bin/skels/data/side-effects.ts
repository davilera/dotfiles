import { select, dispatch } from '@wordpress/data';

import { STORE } from './config';

type SideEffect = Promise< void >;
const SideEffect = Promise;

export async function doSomething(): SideEffect {
	try {
		const oldValue: string = select( STORE ).getValue();
		const newValue: string = await ( async () => 'new-value' )();
		dispatch( STORE ).setValue( oldValue + newValue );
	} catch ( e ) {
		// Nothing to do here.
	} //end try
} //end doSomething()
