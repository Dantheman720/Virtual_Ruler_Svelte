<script lang="ts">
	let lengthInInches = $state(1);
	let ticksPerInch = $state(32);
	let measurement = $state(0);

	interface TickMark {
		position: number;
		major: boolean;
		medium: boolean;
		small: boolean;
		label: string;
	}

	function generateTicks(): TickMark[] {
		const ticks: TickMark[] = [];
		for (let i = 0; i <= lengthInInches * ticksPerInch; i++) {
			ticks.push({
				position: i / ticksPerInch,
				major: i % ticksPerInch === 0,
				medium: i % (ticksPerInch / 8) === 0,
				small: i % (ticksPerInch / 16) === 0,
				label: formatFraction(i, ticksPerInch)
			});
		}
		return ticks;
	}

	function formatFraction(numerator: number, denominator: number): string {
		const gcd = (a: number, b: number): number => b ? gcd(b, a % b) : a;
		const divisor = gcd(numerator, denominator);
		return `${numerator / divisor}/${denominator / divisor}`;
	}

	function convertFractionToDecimal(fraction: string): number {
		const parts = fraction.split('/');
		if (parts.length === 2) {
			const numerator = parseFloat(parts[0]);
			const denominator = parseFloat(parts[1]);
			if (!isNaN(numerator) && !isNaN(denominator) && denominator !== 0) {
				return numerator / denominator;
			}
		}
		return parseFloat(fraction) || 0;
	}

	function handleMeasurementInput(event: any): void {
		const input = event.target?.value.trim() || '';
		measurement = convertFractionToDecimal(input);
	}

	let normalizedMeasurement = $derived(measurement - Math.floor(measurement));
</script>

<style>
    .container {
        width: 100%;
        padding: 10px;
        box-sizing: border-box;
    }

    .input-wrapper {
        margin-bottom: 10px;
    }

    input {
        width: 100%;
        padding: 8px;
        font-size: 16px;
        box-sizing: border-box;
        touch-action: manipulation;
    }

    .ruler {
        position: relative;
        width: 100%;
        height: 60px;
        background: lightgray;
        -webkit-user-select: none;
        user-select: none;
        white-space: nowrap;
        -ms-overflow-style: none; /* IE and Edge */
        scrollbar-width: none; /* Firefox */
        overflow-x: auto; /* Still allows scrolling */
    }

    .ruler::-webkit-scrollbar {
        display: none; /* Chrome, Safari, and Opera */
    }

    .tick {
        position: absolute;
        height: 10px;
        width: 1px;
        background: black;
        transform: translateX(-50%);
    }

    .tick.major {
        height: 30px;
    }

    .tick.medium {
        height: 20px;
    }

    .tick.small {
        height: 15px;
    }

    .tick-label {
        position: absolute;
        font-size: clamp(10px, 2.5vw, 14px);
        transform: translateX(-50%);
        top: 32px;
        white-space: nowrap;
    }

    .marker {
        position: absolute;
        height: 40px;
        width: 2px;
        background-color: red;
        z-index: 100;
        transform: translateX(-50%);
        touch-action: none;
    }

    @media (max-width: 480px) {
        .ruler {
            height: 50px;
        }

        .tick.major {
            height: 25px;
        }

        .tick.medium {
            height: 15px;
        }

        .tick.small {
            height: 10px;
        }

        .marker {
            height: 35px;
            width: 3px;
        }
    }
</style>

<div class="container">
	<div class="input-wrapper">
		<input
			type="number"
			step="0.1"
			on:input={handleMeasurementInput}
			placeholder="Enter measurement (e.g., 0.5)"
		>
	</div>
	<div class="ruler">
		{#each generateTicks() as tick}
			<div
				class="tick {tick.major ? 'major' : tick.medium ? 'medium' : tick.small ? 'small' : ''}"
				style="left: {tick.position / lengthInInches * 100}%;"
			>
				<span class="tick-label">{tick.label}</span>
			</div>
		{/each}
		<div
			class="marker"
			style="left: {normalizedMeasurement / lengthInInches * 100}%"
		></div>
	</div>
</div>