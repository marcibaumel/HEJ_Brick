shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;

uniform float brightness : hint_range(0.5, 2.0) = 1.15;
uniform float curvature : hint_range(0.0, 10.0) = 3.0;

// Vignette: Made very subtle
uniform float vignette_multiplier : hint_range(0.0, 2.0) = 0.2;

// Pixel Grid
uniform float pixel_grid_intensity : hint_range(0.0, 0.5) = 0.01;

// Scanlines
group_uniforms ScanLineSettings;
uniform float scanline_count : hint_range(0.0, 1000.0) = 100.0;
uniform float scanline_speed : hint_range(-5.0, 5.0) = 0.5; // Slower movement
uniform float scanline_opacity : hint_range(0.0, 0.5) = 0.1; // More transparent
group_uniforms;

// chromatic aberration
group_uniforms ChromaticAberrationeSettings;
uniform float chromatic_aberration : hint_range(0.0, 0.1, 0.00001) = 0.0015;
uniform float red_multiplier : hint_range(1.0, 1.5, 0.01) = 1.0;
uniform float green_multiplier : hint_range(1.0, 1.5, 0.01) = 1.0;
uniform float blue_multiplier : hint_range(1.0, 1.5, 0.01) = 1.0;
group_uniforms;

// Flickering
group_uniforms FlickeringSettings;
uniform float flicker_frequency : hint_range(1.0, 3000.0) = 2500.0; // frequency in hertz * 10
uniform float flicker_intensity : hint_range(0.0, 0.1) = 0.002;		// Flicker: Lowered frequency (20.0 instead of 50.0) and lower default intensity
uniform float flicker_cap : hint_range(0.0, 1.0) = 0.20;			// Capping the sin function
group_uniforms;


void fragment() {
    vec2 centered_uv = SCREEN_UV * 2.0 - 1.0;
    vec2 uv_offset = centered_uv.yx / curvature;
    vec2 warped_uv = (centered_uv + centered_uv * uv_offset * uv_offset + 1.0) / 2.0;

	vec3 cat = vec3 (red_multiplier, green_multiplier, blue_multiplier);

    float cutoff = step(0.0, warped_uv.x) * step(warped_uv.x, 1.0) * step(0.0, warped_uv.y) * step(warped_uv.y, 1.0);

    float r = textureLod(screen_texture, warped_uv + vec2(chromatic_aberration, 0.0), 0.0).r;
    float g = textureLod(screen_texture, warped_uv, 0.0).g;
    float b = textureLod(screen_texture, warped_uv - vec2(chromatic_aberration, 0.0), 0.0).b;
    vec3 color = vec3(r, g, b);
	color *= cat;

    float scanline = sin(warped_uv.y * scanline_count * 3.14 + (TIME * scanline_speed));
    scanline = (scanline + 1.0) / 2.0;
    color -= scanline * scanline_opacity;

    float grid = sin(warped_uv.x * scanline_count * 10.0);
    color *= (1.0 - pixel_grid_intensity) + (grid + 1.0) * 0.5 * pixel_grid_intensity;

    float flicker = (sin(TIME * flicker_frequency) * flicker_intensity) * flicker_cap;
    color += flicker;

    float dist = length(centered_uv);
    float vignette = smoothstep(2, 2, dist);
    color *= (1.0 - vignette * vignette_multiplier);

    COLOR = vec4(color * brightness * cutoff, 1.0);
}