/// Maps Grade 10 Science (SNC2D) subtopic codes to the lesson id that
/// covers them in `assets/data/snc2d_topics_mindmap.json`, mirroring
/// grade10_lesson_mapping.dart's pattern. Safe to key by subtopic code
/// alone since these codes don't collide with any other course's codes.
const snc2dLessonIdBySubtopicCode = <String, String>{
  // Biology: Tissues, Organs, and Systems
  'cell-theory-and-structure': 's10bio1',
  'levels-of-organization': 's10bio2',
  'plant-tissues-and-structures': 's10bio3',
  'plant-transport-systems': 's10bio4',
  'animal-tissue-types': 's10bio5',
  'the-circulatory-system': 's10bio6',
  'the-respiratory-system': 's10bio7',
  'the-digestive-system': 's10bio8',
  'homeostasis-and-feedback': 's10bio9',

  // Chemistry: Chemical Reactions
  'atoms-and-the-periodic-table': 's10chem1',
  'chemical-bonding': 's10chem2',
  'naming-compounds': 's10chem3',
  'types-of-chemical-reactions': 's10chem4',
  'balancing-chemical-equations': 's10chem5',
  'intro-to-acids-and-bases': 's10chem6',
  'the-ph-scale': 's10chem7',
  'acid-base-neutralization': 's10chem8',
  'acids-bases-and-the-environment': 's10chem9',

  // Earth and Space Science: Climate Change
  'earths-interconnected-spheres': 's10earth1',
  'weather-vs-climate': 's10earth2',
  'the-greenhouse-effect': 's10earth3',
  'natural-causes-of-climate-change': 's10earth4',
  'human-impact-on-climate': 's10earth5',
  'evidence-of-climate-change': 's10earth6',
  'climate-feedback-loops': 's10earth7',
  'consequences-of-climate-change': 's10earth8',
  'responding-to-climate-change': 's10earth9',

  // Physics: Light and Geometric Optics
  'the-nature-of-light': 's10phys1',
  'rectilinear-propagation': 's10phys2',
  'reflection-of-light': 's10phys3',
  'curved-mirrors': 's10phys4',
  'refraction-of-light': 's10phys5',
  'lenses-and-ray-diagrams': 's10phys6',
  'the-human-eye': 's10phys7',
  'optical-instruments': 's10phys8',
  'light-and-colour': 's10phys9',
};
