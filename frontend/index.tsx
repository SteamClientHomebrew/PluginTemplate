import { IconsModule, definePlugin, Field } from 'millennium';

const SettingsContent = () => {
	return <Field label="Hello, World!" />;
};

/** @ffi */
export function subtract(a: number, b: number): { difference: number; a: number; b: number } {
	console.log("Substracting", a, "from", b);
	return { difference: a - b, a, b };
}

/** @ffi */
export const hookedSettingsIcon = {
	SteamButton: () => <IconsModule.Caution height={'20px'} />
}

async function initializePlugin() {
	console.log("Frontend initialized");

	const sum = await backend.add(100, 100, 100);
	console.log('add result:', sum);

	console.warn('Example warning', { sum, threshold: 150 });
	console.error('Example error', new Error('example error'));
}

export default definePlugin(() => {
	initializePlugin();

	return {
		title: 'My Plugin',
		icon: <IconsModule.Settings />,
		content: <SettingsContent />,
	};
});
