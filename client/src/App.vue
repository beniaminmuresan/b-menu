<script setup>
import { ref } from 'vue'
import axios from 'axios'
import moment from 'moment';

const dietOptions = ref([
  { label: 'Balanced', value: 'balanced', description: 'Protein/Fat/Carb values in 15/35/50 ratio' },
  { label: 'High-Fiber', value: 'high-fiber', description: 'More than 5g fiber per serving' },
  { label: 'High-Protein', value: 'high-protein', description: 'More than 50% of total calories from proteins' },
  { label: 'Low-Carb', value: 'low-carb', description: 'Less than 20% of total calories from carbs' },
  { label: 'Low-Fat', value: 'low-fat', description: 'Less than 15% of total calories from fat' },
  { label: 'Low-Sodium', value: 'low-sodium', description: 'Less than 140mg Na per serving' },
])

const healthOptions = ref([
  { label: 'Alcohol-Cocktail', value: 'alcohol-cocktail', description: 'Describes an alcoholic cocktail' },
  { label: 'Alcohol-Free', value: 'alcohol-free', description: 'No alcohol used or contained' },
  { label: 'Celery-Free', value: 'celery-free', description: 'Does not contain celery or derivatives' },
  { label: 'Crustcean-Free', value: 'crustacean-free', description: 'Does not contain crustaceans (shrimp, lobster etc.) or derivatives' },
  { label: 'Dairy-Free', value: 'dairy-free', description: 'No dairy; no lactose' },
  { label: 'DASH', value: 'DASH', description: 'Dietary Approaches to Stop Hypertension diet' },
  { label: 'Egg-Free', value: 'egg-free', description: 'No eggs or products containing eggs' },
  { label: 'Fish-Free', value: 'fish-free', description: 'No fish or fish derivatives' },
  { label: 'FODMAP-Free', value: 'fodmap-free', description: 'Does not contain FODMAP foods' },
  { label: 'Gluten-Free', value: 'gluten-free', description: 'No ingredients containing gluten' },
  { label: 'Keto-Friendly', value: 'keto-friendly', description: 'Maximum 7 grams of net carbs per serving' },
  { label: 'Kidney-Friendly', value: 'kidney-friendly', description: 'Per serving  – phosphorus less than 250 mg AND potassium less than 500 mg AND sodium less than 500 mg' },
  { label: 'Kosher', value: 'koshe', description: 'Contains only ingredients allowed by the kosher diet. However it does not guarantee kosher preparation of the ingredients themselves' },
  { label: 'Low Potassium', value: 'low-potassium', description: 'Less than 150mg per serving' },
  { label: 'Lupine-Free', value: 'lupine-free', description: 'Does not contain lupine or derivatives' },
  { label: 'Mediterranean', value: 'Mediterranean', description: 'Mediterranean diet' },
  { label: 'Mollusk-Free', value: 'mollusk-free', description: 'No mollusks' },
  { label: 'Mustard-Free', value: 'mustard-free', description: 'Does not contain mustard or derivatives' },
  { label: 'No oil added', value: 'No-oil-added', description: 'No oil added except to what is contained in the basic ingredients' },
  { label: 'Paleo', value: 'paleo', description: 'Excludes what are perceived to be agricultural products; grains, legumes, dairy products, potatoes, refined salt, refined sugar, and processed oils' },
  { label: 'Peanut-Free', value: 'peanut-free', description: 'No peanuts or products containing peanuts' },
  { label: 'Pescatarian', value: 'pecatarian', description: 'Does not contain meat or meat based products, can contain dairy and fish' },
  { label: 'Pork-Free', value: 'pork-free', description: 'Does not contain pork or derivatives' },
  { label: 'Red-Meat-Free', value: 'red-meat-free', description: 'Does not contain beef, lamb, pork, duck, goose, game, horse, and other types of red meat or products containing red meat.' },
  { label: 'Sesame-Free', value: 'sesame-free', description: 'Does not contain sesame seed or derivatives' },
  { label: 'Shellfish-Free', value: 'shellfish-free', description: 'No shellfish or shellfish derivatives' },
  { label: 'Soy-Free', value: 'soy-free', description: 'No soy or products containing soy' },
  { label: 'Low sugar', value: 'sugar-conscious', description: 'Less than 4g of sugar per serving' },
  { label: 'Sulfite-Free', value: 'sulfite-free', description: 'No Sulfites' },
  { label: 'Tree-Nut-Free', value: 'tree-nut-free', description: 'No tree nuts or products containing tree nuts' },
  { label: 'Vegan', value: 'vegan', description: 'No meat, poultry, fish, dairy, eggs or honey' },
  { label: 'Vegetarian', value: 'vegetarian', description: 'No meat, poultry, or fish' },
  { label: 'Wheat-Free', value: 'wheat-free', description: 'No wheat, can have gluten though' }
])

const cuisineOptions = ref([
  { value: 'american', label: 'American' },
  { value: 'asian', label: 'Asian' },
  { value: 'british', label: 'British' },
  { value: 'caribbean', label: 'Caribbean' },
  { value: 'central europe', label: 'Central europe' },
  { value: 'chinese', label: 'Chinese' },
  { value: 'eastern europe', label: 'Eastern europe' },
  { value: 'french', label: 'French' },
  { value: 'greek', label: 'Greek' },
  { value: 'indian', label: 'Indian' },
  { value: 'italian', label: 'Italian' },
  { value: 'japanese', label: 'Japanese' },
  { value: 'korean', label: 'Korean' },
  { value: 'kosher', label: 'Kosher' },
  { value: 'mediterranean', label: 'Mediterranean' },
  { value: 'mexican', label: 'Mexican' },
  { value: 'middle eastern', label: 'Middle eastern' },
  { value: 'nordic', label: 'Nordic' },
  { value: 'south american', label: 'South american' },
  { value: 'south east asian', label: 'South east asian' },
  { value: 'world', label: 'World' }
])

const userData = ref({
  selectedDietOptions: [{ label: 'Balanced', value: 'balanced', description: 'Protein/Fat/Carb values in 15/35/50 ratio' }],
  selectedHealthOptions: [{ label: 'Low sugar', value: 'sugar-conscious', description: 'Less than 4g of sugar per serving' }],
  selectedCuisineOptions: [{ value: 'french', label: 'French' }, { value: 'italian', label: 'Italian' }, { value: 'asian', label: 'Asian' }]
})

const recipesData = ref({})

const generateMenu = () => {
  axios
    .post('http://localhost:3000/daily_menus', {
      "diet": userData.value.selectedDietOptions.map(diet => diet.value),
      "health": userData.value.selectedHealthOptions.map(health => health.value),
      "cuisine": userData.value.selectedCuisineOptions.map(cuisine => cuisine.value)
    }, {
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json'
      }
    })
    .then((response) => {
      recipesData.value = response.data
    })
}
</script>

<template>
  <transition-group appear enter-active-class="animated zoomIn">
    <div class="column items-center">
      <div key="header" class="row q-pa-sm">
        <div class="text-center">
          <img src="logo.png" />
          <p class="text-h5" style="font-family: Algerian;">
            PERSONALIZED MEAL PLANNER
          </p>
        </div>
      </div>

      <div key="diet" class="row q-pa-sm">
        <q-select filled bg-color="green" use-chips v-model="userData.selectedDietOptions" multiple :options="dietOptions"
          stack-label label="Diet" class="select-buttons" />
        <!-- <div class="text-green">
          <q-icon name="help" size="xl">
            <q-tooltip anchor="bottom middle" self="top middle">
              <ol>
                <li v-for="dietOption in dietOptions"><b>{{ dietOption.label }}</b>: {{ dietOption.description }}</li>
              </ol>
            </q-tooltip>
          </q-icon>
        </div> -->
      </div>

      <div key="health" class="row q-pa-sm">
        <q-select filled bg-color="light-green" use-chips v-model="userData.selectedHealthOptions" multiple
          :options="healthOptions" stack-label label="Health" class="select-buttons" />
        <!-- <div class="text-light-green">
          <q-icon name="help" size="xl">
            <q-tooltip anchor="bottom middle" self="top middle">
              <ol>
                <li v-for="healthOption in healthOptions"><b>{{ healthOption.label }}</b>: {{ healthOption.description }}</li>
              </ol>
            </q-tooltip>
          </q-icon>
        </div> -->
      </div>

      <div key="cuisine" class="row q-pa-sm">
        <q-select filled bg-color="lime" use-chips v-model="userData.selectedCuisineOptions" multiple
          :options="cuisineOptions" stack-label label="Cuisine" class="select-buttons" />
      </div>

      <div key="generate-button" class="row q-pa-sm">
        <div class="text-center">
          <q-btn color="black" label="Generate menu" @click="generateMenu" />
        </div>
      </div>
    </div>
  </transition-group>

  <div v-if="recipesData">
    <div v-for="date in Object.keys(recipesData)">
      <div class="row justify-center text-h5 bold"> {{ moment(date).format('dddd') }}</div>
      <div class="row justify-center">
        <div v-for="recipeData in recipesData[date]">
          <q-card class="my-card q-ma-sm">
            <q-img :src="recipeData.image">
              <div class="absolute-bottom">
                <div>{{ recipeData.time_serve }}</div>
                <div class="text-h6">{{ recipeData.label }}</div>
              </div>
            </q-img>
            <q-card-actions>
              <q-btn flat>Vezi Reţeta</q-btn>
            </q-card-actions>
          </q-card>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.my-card {
  width: 250px;
}

.select-buttons {
  width: 400px;
}
</style>
