import { definePlugin, Field } from 'millennium';
import { useEffect, useState } from 'react';

const SettingsContent = () => {
	return <Field label="Hello, World!" />;
};

/** @ffi */
export function subtract(a: number, b: number): { difference: number; a: number; b: number } {
	console.log('Substracting', a, 'from', b);
	return { difference: a - b, a, b };
}

const Icon = () => {
	const [icon, setIcon] = useState<string>();

	useEffect(() => {
		console.log('Getting icon...');
		backend.getSteamBrewIconResource().then(setIcon);
	}, []);

	return (
		<div
			className="SteamClientHomebrewIcon"
			style={{
				width: '16px',
				height: '16px',
				marginRight: '5px',
			}}
			dangerouslySetInnerHTML={{ __html: icon }}
		/>
	);
};

/** @ffi */
export const hookedSettingsIcon = {
	SteamButton: () => <Icon />,
};

async function initializePlugin() {
	console.log('Frontend initialized');

	const sum = await backend.add(100, 100, 100);
	console.log('add result:', sum);

	console.warn('Example warning', { sum, threshold: 150 });
	console.error('Example error', new Error('example error'));
}

export default definePlugin(() => {
	initializePlugin();

	return {
		title: 'My Plugin',
		icon: <Icon />,
		content: <SettingsContent />,
	};
});
