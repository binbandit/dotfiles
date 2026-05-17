// Afterglow — warm ambient glow with cinematic vignette
//
// A subtle post-processing pass for dark themes.
// Adds a soft radiance to the background center and
// gently darkens the edges for depth and focus.
// No loops, no extra texture reads — zero-cost beauty.

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec4 col = texture(iChannel0, uv);

    float luminance = dot(col.rgb, vec3(0.2126, 0.7152, 0.0722));

    // ── Warm ambient glow ──
    // Gaussian falloff from just above center; only touches dark pixels
    // so text stays crisp while the background breathes.
    float dist = length((uv - vec2(0.5, 0.45)) * vec2(1.0, 0.9));
    float glow = exp(-dist * dist * 3.0);
    float bgMask = smoothstep(0.08, 0.02, luminance);
    col.rgb += vec3(0.055, 0.035, 0.015) * glow * bgMask;

    // ── Vignette ──
    // Warm-tinted edge darkening: blues recede first,
    // giving corners a faintly amber cast.
    vec2 v = uv * (1.0 - uv);
    float vig = clamp(pow(v.x * v.y * 15.0, 0.2), 0.0, 1.0);
    col.rgb *= mix(vec3(0.90, 0.88, 0.85), vec3(1.0), vig);

    fragColor = col;
}
