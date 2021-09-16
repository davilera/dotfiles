// ==================
//   APP TYPES
// ==================

export type State = OneState | AnotherState;

export type OneState = {
	readonly status: 'one-state';
	readonly value: string;
};

export type AnotherState = {
	readonly status: 'another-state';
};
