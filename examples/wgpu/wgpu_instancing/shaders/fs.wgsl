struct FragmentOutput {
    [[location(0)]] f_color: vec4<f32>;
};

[[block]]
struct Data {
    world: mat4x4<f32>;
    view: mat4x4<f32>;
    proj: mat4x4<f32>;
    time: f32;
};

[[group(0), binding(0)]]
var<uniform> uniforms: Data;

fn sinN(n : f32) -> f32 {
    return (sin(n)+1.0)/2.0;
}

[[stage(fragment)]]
fn main(
    [[location(0)]] normal: vec3<f32>,
    [[location(1)]] color: vec3<f32>,
) -> FragmentOutput {
    let light: vec3<f32> = vec3<f32>(0.0, 0.0, 1.0);
    let brightness: f32 = dot(normalize(normal), normalize(light));
    let dark_color: vec3<f32> = vec3<f32>(0.1, 0.1+sinN(uniforms.time)*0.5, 0.1) * color;
    let out_color = vec4<f32>(mix(dark_color, color, vec3<f32>(brightness)), 1.0);
    return FragmentOutput(out_color);
}
