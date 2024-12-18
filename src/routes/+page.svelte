<script lang="ts">
	let lengthInInches = $state(1); // Adjust length of the ruler to 1 inch
	let ticksPerInch = $state(32); // Number of subdivisions per inch
	let measurement = $state(0); // User-inputted measurement

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
		return parseFloat(fraction) || 0; // Return 0 if not a valid number
	}

	function handleMeasurementInput(event: any): void {
		const input = event.target ? event.target.value.trim() : '';
		measurement = convertFractionToDecimal(input);
	}

	let normalizedMeasurement = $derived(measurement - Math.floor(measurement));

</script>

<style>
    .ruler {
        position: relative;
        width: 100%;
        height: 50px;
        background: lightgray;
    }

    .tick {
        position: absolute;
        height: 10px;
        width: 1px;
        background: black;
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
        font-size: 14px;
        transform: translateX(-50%);
        top: 30px;
    }

    .marker {
        position: absolute;
        height: 40px;
        width: 2px;
        background-color: red;
        z-index: 100;
    }
</style>


<input type="text" oninput={handleMeasurementInput} placeholder="Enter measurement in inches (e.g., 1/2, 0.5)">
<div class="ruler">
	{#each generateTicks() as tick}
		<div class="tick {tick.major ? 'major' : tick.medium ? 'medium' : tick.small ? 'small' : ''}"
				 style="left: {tick.position / lengthInInches * 100}%;">
			<span class="tick-label">{tick.label}</span>
		</div>
	{/each}
	<div class="marker" style="left: {normalizedMeasurement / lengthInInches * 100}%"></div>
</div>