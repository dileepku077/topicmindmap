/// Maps Grade 11 Physics (SPH3U) subtopic codes to the lesson id that
/// covers them in `assets/data/sph3u_topics_mindmap.json`, mirroring
/// grade10_lesson_mapping.dart's pattern. Safe to key by subtopic code
/// alone since these codes don't collide with any other course's codes.
const sph3uLessonIdBySubtopicCode = <String, String>{
  // Kinematics
  'position-distance-displacement': 'p11kin1',
  'speed-and-velocity': 'p11kin2',
  'acceleration': 'p11kin3',
  'uniform-acceleration-equations': 'p11kin4',
  'motion-graphs': 'p11kin5',
  'free-fall-and-gravity': 'p11kin6',
  'projectile-motion': 'p11kin7',
  'relative-velocity': 'p11kin8',

  // Dynamics
  'newtons-first-law': 'p11dyn1',
  'newtons-second-law': 'p11dyn2',
  'newtons-third-law': 'p11dyn3',
  'gravity-and-weight': 'p11dyn4',
  'friction': 'p11dyn5',
  'free-body-diagrams': 'p11dyn6',
  'applications-of-newtons-laws': 'p11dyn7',
  'uniform-circular-motion': 'p11dyn8',

  // Energy and Momentum
  'work-and-energy': 'p11nrg1',
  'kinetic-energy': 'p11nrg2',
  'gravitational-potential-energy': 'p11nrg3',
  'conservation-of-energy': 'p11nrg4',
  'power': 'p11nrg5',
  'momentum-and-impulse': 'p11nrg6',
  'conservation-of-momentum': 'p11nrg7',
  'elastic-and-inelastic-collisions': 'p11nrg8',

  // Waves and Sound
  'properties-of-waves': 'p11wav1',
  'wave-interference': 'p11wav2',
  'standing-waves': 'p11wav3',
  'nature-of-sound': 'p11wav4',
  'resonance-and-music': 'p11wav5',
  'doppler-effect': 'p11wav6',
  'sound-intensity-decibels': 'p11wav7',

  // Electricity and Magnetism
  'electric-charge-and-static': 'p11elec1',
  'electric-current-and-circuits': 'p11elec2',
  'ohms-law': 'p11elec3',
  'series-and-parallel-circuits': 'p11elec4',
  'electrical-power-and-energy': 'p11elec5',
  'magnetism-and-magnetic-fields': 'p11elec6',
  'electromagnetism': 'p11elec7',
};
