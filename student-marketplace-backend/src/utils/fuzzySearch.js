const fuse = require('fuse.js');

search = (posts, query)  => {
    const fuzzySearch = new fuse(posts, {
        keys: [
            'title'
        ]
    });

    return fuzzySearch.search(query);
}

module.exports = {
 search
}