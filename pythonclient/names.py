import random

animal_adjectives = [
  'adorable',
  'adventurous',
  'aggressive',
  'alert',
  'blushing',
  'bright',
  'clear',
  'cloudy',
  'colorful',
  'crowded',
  'distinct',
  'elegant',
  'excited',
  'fancy',
  'glamorous',
  'gleaming',
  'graceful',
  'handsome',
  'light',
  'magnificent',
  'misty',
  'motionless',
  'muddy',
  'poised',
  'precious',
  'quaint',
  'shiny',
  'smoggy',
  'sparkling',
  'spotless',
  'stormy',
  'strange',
  'brainy',
  'busy',
  'careful',
  'cautious',
  'clever',
  'curious',
  'different',
  'doubtful',
  'famous',
  'gifted',
  'helpful',
  'inquisitive',
  'odd',
  'outstanding',
  'powerful',
  'prickly',
  'puzzled',
  'rich',
  'shy',
  'sleepy',
  'super',
  'talented',
  'tender',
  'tough',
  'vast',
  'wandering',
  'wild',
  'wrong',
  'agreeable',
  'amused',
  'brave',
  'calm',
  'charming',
  'cheerful',
  'comfortable',
  'cooperative',
  'courageous',
  'delightful',
  'determined',
  'eager',
  'elated',
  'enchanting',
  'encouraging',
  'energetic',
  'enthusiastic',
  'excited',
  'exuberant',
  'fair',
  'faithful',
  'fantastic',
  'friendly',
  'funny',
  'gentle',
  'glorious',
  'happy',
  'healthy',
  'helpful',
  'hilarious',
  'jolly',
  'joyous',
  'kind',
  'lively',
  'lovely',
  'lucky',
  'nice',
  'perfect',
  'pleasant',
  'proud',
  'relieved',
  'silly',
  'smiling',
  'splendid',
  'successful',
  'thankful',
  'thoughtful',
  'victorious',
  'witty',
  'wonderful',
  'zealous',
  'zany'
]

animal_nouns = [
'aardvark',
'albatross',
'alligator',
'alpaca',
'anteater',
'antelope',
'armadillo',
'badger',
'barracuda',
'bat',
'bear',
'bee',
'bison',
'boar',
'butterfly',
'camel',
'caribou',
'cat',
'caterpillar',
'cheetah',
'chinchilla',
'cobra',
'coyote',
'crocodile',
'crow',
'deer',
'dinosaur',
'dolphin',
'dove',
'dragonfly',
'duck',
'eagle',
'elephant',
'elk',
'emu',
'falcon',
'ferret',
'finch',
'fish',
'flamingo',
'fox',
'frog',
'gazelle',
'gerbil',
'giraffe',
'goose',
'goldfish',
'grasshopper',
'grouse',
'hamster',
'hare',
'hawk',
'hedgehog',
'heron',
'herring',
'hornet',
'horse',
'hummingbird',
'hyena',
'jackal',
'jaguar',
'jellyfish',
'kangaroo',
'koala',
'lark',
'lemur',
'leopard',
'lion',
'llama',
'lobster',
'locust',
'magpie',
'mallard',
'manatee',
'meerkat',
'mink',
'moose',
'mouse',
'narwhal',
'newt',
'nightingale',
'octopus',
'opossum',
'ostrich',
'otter',
'owl',
'ox',
'partridge',
'pelican',
'penguin',
'pheasant',
'pig',
'pigeon',
'pony',
'porcupine',
'quail',
'rabbit',
'raccoon',
'herd',
'reindeer',
'rhinoceros',
'salamander',
'salmon',
'sandpiper',
'scorpion',
'seahorse',
'shark',
'sheep',
'snail',
'spider',
'squid',
'squirrel',
'starling',
'stingray',
'stork',
'swan',
'tiger',
'toad',
'trout',
'poultry',
'turtle',
'wallaby',
'walrus',
'wasp',
'wolf',
'wolverine',
'wombat',
'wren',
'yak',
'zebra',
]

nature_adjectives = [
    'autumn', 'hidden', 'bitter', 'misty', 'silent',
  'dark', 'summer', 'icy', 'delicate', 'quiet', 'white', 'cool',
  'spring', 'winter', 'patient', 'twilight', 'dawn', 'crimson', 'wispy',
  'blue', 'billowing', 'broken', 'cold', 'falling',
  'frosty', 'green', 'long', 'late', 'lingering', 'bold', 'little', 'morning',
  'muddy', 'old', 'red', 'rough', 'still', 'small', 'sparkling', 'throbbing',
  'shy', 'wandering', 'withered', 'wild', 'black', 'holy', 'solitary',
  'fragrant', 'aged', 'snowy', 'proud', 'floral', 'restless', 'divine',
  'polished', 'purple', 'lively', 'nameless', 'puffy', 'fluffy',
  'calm', 'young', 'golden', 'avenging', 'ancestral', 'ancient', 'argent',
  'reckless', 'daunting', 'short', 'rising', 'strong', 'tumbling',
  'silver', 'dusty', 'celestial', 'cosmic', 'crescent', 'double', 'far',
  'inner', 'milky', 'northern', 'southern', 'eastern', 'western', 'outer',
  'terrestrial', 'deep', 'epic', 'mighty', 'powerful'
  ]
nature_nouns = [
    'waterfall', 'river', 'breeze', 'moon', 'rain',
  'wind', 'sea', 'morning', 'snow', 'lake', 'sunset', 'pine', 'shadow', 'leaf',
  'dawn', 'glitter', 'forest', 'hill', 'cloud', 'meadow', 'glade',
  'bird', 'brook', 'butterfly', 'dew', 'dust', 'field',
  'flower', 'firefly', 'feather', 'grass', 'haze', 'mountain', 'night', 'pond',
  'darkness', 'snowflake', 'silence', 'sound', 'sky', 'shape', 'surf',
  'thunder', 'violet', 'wildflower', 'wave', 'water', 'resonance',
  'sun', 'wood', 'dream', 'cherry', 'tree', 'fog', 'frost', 'voice', 'paper',
  'frog', 'smoke', 'star', 'sierra', 'castle', 'fortress', 'tiger', 'day',
  'sequoia', 'cedar', 'wrath', 'blessing', 'spirit', 'nova', 'storm', 'burst',
  'protector', 'drake', 'dragon', 'knight', 'fire', 'king', 'jungle', 'queen',
  'giant', 'elemental', 'throne', 'game', 'weed', 'stone', 'apogee', 'bang',
  'cluster', 'corona', 'cosmos', 'equinox', 'horizon', 'light', 'nebula',
  'solstice', 'spectrum', 'universe', 'magnitude', 'parallax'
  ]

def get_student_nickname():
    return "-".join([random.choice(animal_adjectives), random.choice(animal_nouns)])

def main():
    print(random.choice(animal_nouns))

if __name__ == '__main__':
    main()