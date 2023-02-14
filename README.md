<h1 align=center>emojify.lua</h1>

<h3 align=center>A fast emoji library for Lua</h3>

<h2>Functions</h2>

<h3>emojify.emojify</h3>

```lua
emojify.emojify("I didn't find any :bug:s in my program") -> "I didn't find any 🐛s in my program"
```

<h3>emojify.get</h3>

```lua
emojify.get('apple') -> "🍎"
```

<h3>emojify.which</h3>

```lua
emojify.which('🍎') -> "apple"
```

<h3>emojify.find</h3>

```lua
emojify.find('city') -> { { value = '🌇', key = 'city_sunrise' }, { value = '🌆', key = 'city_sunset' }, { value = '🏙️', key = 'cityscape' } }
```

<h3>emojify.random</h3>

```lua
emojify.random() -> "⭕"
```
